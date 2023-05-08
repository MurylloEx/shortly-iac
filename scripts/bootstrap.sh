#!/bin/bash

# Atualização dos repositórios Linux
sudo apt-get update -y

# Instalação do Node.js v14
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalação do CodeDeploy Agent
sudo apt-get install -y ruby-full
sudo apt-get install -y wget

cd /home/ubuntu

wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install

chmod +x ./install

sudo ./install auto
sudo rm -f ./install
sudo service codedeploy-agent start

# Instalação do NestJS CLI
sudo npm install -g @nestjs/cli

# Criando um serviço no sistema
cd /etc/systemd/system

sudo sh -c "cat > /etc/systemd/system/${APP_SERVICE_NAME}.service << EOF
[Unit]
Description=${APP_SERVICE_DESCRIPTION}
StartLimitBurst=5
StartLimitIntervalSec=10

[Service]
Type=simple
Restart=on-failure
RestartSec=1
User=root
WorkingDirectory=${APP_SERVICE_BASE_PATH}/${APP_STAGE}-${APP_SERVICE_NAME}/
ExecStart=${APP_SERVICE_BASE_PATH}/${APP_STAGE}-${APP_SERVICE_NAME}/scripts/server/start_server
ExecReload=${APP_SERVICE_BASE_PATH}/${APP_STAGE}-${APP_SERVICE_NAME}/scripts/server/reload_server
ExecStop=${APP_SERVICE_BASE_PATH}/${APP_STAGE}-${APP_SERVICE_NAME}/scripts/server/stop_server

[Install]
WantedBy=multi-user.target
EOF"

# Iniciando o serviço no sistema
sudo systemctl daemon-reload
sudo systemctl enable "${APP_SERVICE_NAME}.service"
sudo systemctl start ${APP_SERVICE_NAME}
