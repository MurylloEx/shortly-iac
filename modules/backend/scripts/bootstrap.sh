#!/bin/bash

# Atualização dos repositórios Linux
sudo apt-get update -y

# Instalação do Node.js v16
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalação do CodeDeploy Agent
sudo apt-get install -y ruby-full
sudo apt-get install -y wget

cd /tmp

wget https://aws-codedeploy-${AWS_REGION}.s3.${AWS_REGION}.amazonaws.com/latest/install

chmod +x ./install

sudo ./install auto
sudo rm -f ./install
sudo service codedeploy-agent start

# Instalação do NestJS CLI
sudo npm install -g @nestjs/cli

# Criando um serviço no sistema
cd /etc/systemd/system

sudo sh -c "cat > /etc/systemd/system/${APP_SERVICE_NAME}.service << EOF
${DAEMON_SERVICE_CONTENT}
EOF"

# Iniciando o serviço no sistema
sudo systemctl daemon-reload
sudo systemctl enable "${APP_SERVICE_NAME}.service"
sudo systemctl start ${APP_SERVICE_NAME}
