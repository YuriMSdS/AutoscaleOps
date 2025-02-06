# AutoScaleOps

## Visão Geral
O **AutoScaleOps** é um projeto para criação e gerenciamento automático de escalonamento vertical de máquinas virtuais na AWS. A solução utiliza **Terraform** para provisionamento de infraestrutura, **scripts Bash** para monitoramento de recursos e decisão de escalonamento, além de uma **pipeline Jenkins** para aplicação automática das mudanças. Ou seja, meu objetivo com este projeto é poder provisionar uma infraestrutura que possa se adaptar de acordo com uso, evidando gastos desnecessários e interferência humana.

## Processos
1. **Criação da VM:** Terraform é utilizado para provisionar a instância EC2.
2. **Monitoramento:** Um script Bash monitora o consumo de **memória** e **rede** da VM.
3. **Decisão de Escalonamento:** O script decide se a máquina deve **escalar para cima** (t2.small) ou **para baixo** (t2.nano).
4. **Aplicação da Mudança:** A pipeline Jenkins executa a atualização da instância via Terraform.
5. **Ambiente em Docker:** Jenkins roda em um container Docker configurado com **AWS CLI** e **Terraform**.

## Requisitos
- Conta AWS com permissões para gerenciar EC2 e S3.
- Chave SSH cadastrada na AWS para acesso à VM.
- Terraform instalado.
- Jenkins com pipeline configurada.
- Docker instalado para rodar a pipeline.

## Configuração e Uso
### 1. Clonar o Repositório
```bash
 git clone https://github.com/YuriMSdS/AutoscaleOps.git
 cd AutoscaleOps
```

### 2. Configurar Credenciais AWS
No ambiente Jenkins ou localmente, exporte as credenciais AWS:
```bash
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
export AWS_REGION=us-east-2
```

### 3. Criar a Infraestrutura
```bash
cd Infrastructure
terraform init
terraform apply -auto-approve
```
Isso criará a VM inicial com tipo `t2.micro`.

### 4. Configurar a Pipeline no Jenkins
- No Jenkins, crie um novo pipeline e copie o conteúdo do `Jenkinsfile`.
- Adicione uma credencial SSH (`ssh-key-id`) para conexão com a VM.
- Execute a pipeline.

### 5. Monitoramento e Escalonamento
O script `monitor_resources.sh` avalia os recursos da VM e decide se deve escalonar:
- **Escalar para cima:** Se uso alto, a VM é alterada para `t2.small`.
- **Escalar para baixo:** Se uso baixo, a VM é alterada para `t2.nano`.

### 6. Executar a Pipeline Manualmente (Opcional)
```bash
jenkins build AutoScaleOps
```

## Estrutura do Projeto
```
.
├── Infrastructure
│   ├── docker
│   │   ├── Dockerfile
│   │   └── entrypoint.sh
│   ├── jenkins
│   │   ├── Jenkinsfile
│   ├── main.tf
│   ├── providers.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── scripts
│   ├── monitor_resources.sh
│   ├── scale_down.sh
│   └── scale_up.sh
├── README.md
└── .gitignore  # Adicionar exclusões para terraform.tfstate e chaves privadas
```

## Considerações Finais
O AutoScaleOps oferece uma solução eficiente para otimizar custos de infraestrutura na AWS, garantindo que a VM se ajuste automaticamente à demanda. O projeto pode ser expandido para incluir novos gatilhos de escalonamento e métricas adicionais.

### Status atual: Em andamento

