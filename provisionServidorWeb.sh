#!/bin/bash
sudo apt update

sudo echo "INSTALANDO CONSUL"
sudo wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

sudo echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

if [ $(dpkg-query -W -f='${Status}' consul 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt install -y consul
fi

sudo echo "INSTALANDO NODEJS"
if [ $(dpkg-query -W -f='${Status}' nodejs 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt install -y nodejs
fi

sudo echo "INSTALANDO NPM"
if [ $(dpkg-query -W -f='${Status}' npm 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt install -y npm
fi

sudo echo "CREANDO CARPETA DE LA APP"
mkdir -p app

npm install --prefix ./app consul

npm install --prefix ./app express


