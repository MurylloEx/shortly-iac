#!/bin/sh

# Criando o arquivo carregador das variáveis de ambiente do SSM
SsmParameters=$(aws ssm get-parameters-by-path --path "/${APP_NAME}/${APP_STAGE}" --region ${AWS_REGION} --recursive --with-decrypt | jq -r '.Parameters[] | "export " + (.Name | split("/")[-1]) + "=\"" + .Value + "\""')

eval $SsmParameters
