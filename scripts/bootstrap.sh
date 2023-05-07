#!/bin/bash

# Atualização dos repositórios
sudo apt update

# Instalação do Node.js v14
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalação do CodeDeploy Agent
sudo apt install ruby-full
sudo apt install wget

cd /home/ubuntu

wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install

chmod +x ./install

sudo ./install auto
sudo service codedeploy-agent status

# Criação do diretório de implantação

