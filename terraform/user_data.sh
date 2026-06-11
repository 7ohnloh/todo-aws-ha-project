#!/bin/bash
set -euo pipefail

dnf update -y
dnf install -y git nodejs
npm install -g pm2

cd /opt
git clone "${repository}" todo-aws-ha-project
cd /opt/todo-aws-ha-project/app
npm install --omit=dev

install -m 600 /dev/null /etc/todo-app.env
echo "DB_HOST=$(echo '${db_host_b64}' | base64 -d)" >> /etc/todo-app.env
echo "DB_USER=$(echo '${db_user_b64}' | base64 -d)" >> /etc/todo-app.env
echo "DB_PASSWORD=$(echo '${db_password_b64}' | base64 -d)" >> /etc/todo-app.env
echo "DB_NAME=$(echo '${db_name_b64}' | base64 -d)" >> /etc/todo-app.env
echo "DB_PORT=$(echo '${db_port_b64}' | base64 -d)" >> /etc/todo-app.env
echo "PORT=3000" >> /etc/todo-app.env

cat > /etc/systemd/system/todo-app.service <<'EOF'
[Unit]
Description=AWS To-Do List Node.js Application
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/todo-aws-ha-project/app
EnvironmentFile=/etc/todo-app.env
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now todo-app
