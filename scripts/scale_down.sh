#!/bin/bash
echo "Reduzindo a configuração..."
terraform apply -auto-approve -var="instance_type=t2.nano"