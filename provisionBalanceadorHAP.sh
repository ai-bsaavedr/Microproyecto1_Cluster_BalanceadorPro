#!/bin/bash

sudo apt update

sudo echo "INSTALANDO NODEJS"
if [ $(dpkg-query -W -f='${Status}' nodejs 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
  sudo apt install -y nodejs
  sudo npm install -g artillery
fi

sudo apt purge -y haproxy

echo "Instalando Haproxy"
if [ $(dpkg-query -W -f='${Status}' haproxy 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt install -y haproxy
fi

echo "Configuración Haproxy"
sudo echo "
backend web-backend
    balance roundrobin
    stats enable
    stats auth admin:admin
    stats uri /haproxy?stats

    server-template mywebapp1 10 _microservicioWeb1._tcp.service.consul resolvers consul1    resolve-opts allow-dup-ip resolve-prefer ipv4 check
    server-template mywebapp2 10 _microservicioWeb2._tcp.service.consul resolvers consul2    resolve-opts allow-dup-ip resolve-prefer ipv4 check

resolvers consul1
    nameserver consul 192.168.100.10:8600
    accepted_payload_size 8192
    hold valid 5s

resolvers consul2
    nameserver consul 192.168.100.11:8600
    accepted_payload_size 8192
    hold valid 5s

frontend http
    bind *:80
    default_backend web-backend" >> /etc/haproxy/haproxy.cfg

sudo cat <<EOF > /etc/haproxy/errors/503.http
HTTP/1.0 503 Service Unavailable
Cache-Control: no-cache
Connection: close
Content-Type: text/html

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>503 Service Unavailable</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        h1 {
            color: #ff6347;
            text-align: center;
            margin-top: 50px;
        }
        p {
            font-size: 18px;
            line-height: 1.5;
            text-align: center;
            margin-top: 20px;
            margin-bottom: 50px;
        }
    </style>
</head>
<body>
    <h1>503 Service Unavailable</h1>
    <p>SORRY! The server is temporarily unable to service your request due to maintenance downtime or capacity problems. Please try again later.</p>
</body>
</html>
EOF

sudo systemctl restart haproxy

sleep 5

sudo artillery run SyncFolder/Haproxy/load_test.yml








