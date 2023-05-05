#!/bin/bash

# Instalação do Node.js v14
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Clone do projeto do GitHub

sudo mkdir -p "${GITHUB_CLONE_PATH}"
sudo git clone https://${GITHUB_PERSONAL_TOKEN}@github.com/${GITHUB_REPOSITORY_USER_NAME}/${GITHUB_REPOSITORY_NAME}.git ${GITHUB_FINAL_CLONE_NAME}

