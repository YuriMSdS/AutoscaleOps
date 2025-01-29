pipeline {
    environment {
        PATH = "/usr/local/bin:/usr/bin:/bin"
        TF_WORKDIR = "/app/Infrastructure"
        AWS_REGION = 'us-east-2'
    }

    agent any

    stages {
        stage('Preparação') {
            steps {
                echo "Iniciando ambiente com Docker..."
                sh '''
                echo "Verificando versões..."
                terraform -version
                aws --version
                '''
            }
        }

        stage('Monitoramento de Recursos') {
            steps {
                echo "Monitorando uso de recursos..."
                script {
                    def result = sh(
                        script: "bash ${TF_WORKDIR}/monitor/monitor_resources.sh",
                        returnStdout: true
                    ).trim()
                    
                    if (result == "1") {
                        env.ACTION = "scale_up"
                    } else if (result == "2") {
                        env.ACTION = "scale_down"
                    } else {
                        env.ACTION = "no_action"
                    }
                }
            }
        }

        stage('Aplicar Mudanças com Terraform') {
            when {
                expression { env.ACTION == "scale_up" || env.ACTION == "scale_down" }
            }
            steps {
                script {
                    def instanceType = env.ACTION == "scale_up" ? "t2.small" : "t2.nano"
                    echo "Executando ${env.ACTION.replace('_', ' ')} para ${instanceType}..."
                    sh """
                    cd ${TF_WORKDIR}
                    terraform init
                    terraform apply -auto-approve -var="instance_type=${instanceType}"
                    """
                }
            }
        }

        stage('Conexão SSH na VM') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key-id', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@IP_DA_VM "echo 'Conexão SSH realizada'"
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finalizada!"
        }
    }
}
