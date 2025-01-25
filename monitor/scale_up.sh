#!/bin/bash
echo "Aumentando a configuração..."
terraform apply -auto-approve -var="instance_type=t2.medium"