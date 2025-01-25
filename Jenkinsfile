pipeline {
    agent any
    
    parameters {
        string(name: 'ACTION', defaultValue: 'upgrade', description: 'Define se vai escalar ou reduzir')
    }
    environment {
        TF_WORKDIR = "/Users/yurimiguel/Desktop/AutoscaleOps"
        AWS_ACCESS_KEY_ID = credentials('aws-credentials')
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials')
        AWS_REGION = 'us-east-2'
    }

    stages {
        stage('Preparação') {
            steps {
              echo "Preparando o ambiente..."
              sh 'terraform -version'
            }
        }
        stage ('Monitoramento de recursos'){
            steps {
                echo "Monitorando recursos..."

                script {
                    def result = sh (
                      script: "${TF_WORKDIR}/monitor_resources.sh",
                      returnStatus: true
                    )
                    if (result == 1) {
                        currentBuild.description = "Scale up necessário"
                        env.ACTION = "scale_up"
                    } else if (result == 2) {
                        currentBuild.description = "Scale down necessário"
                        env.ACTION = "scale_down"
                    } else {
                        currentBuild.description = "Nenhuma ação necessária"
                        env.ACTION= "no_action"
                    }

                }
                
            }
        }
        stage ('Aplicar açãp necessária') {
            
            when {
                expression { env.ACTION == "scale_up" || env.ACTION == "scale_down" }
            }
            steps {
                script {
                    if (env.ACTION == "scale_up") {
                        sh "${env.TF_WORKDIR}/scale_up.sh"
                    } else if (env.ACTION == "scale_down") {
                        sh "${env.TF_WORKDIR}/scale_down.sh"
                    }
                }
            }

        }
    }
}