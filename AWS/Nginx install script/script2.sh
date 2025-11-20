#!/bin/bash

# Update system
apt update -y

# Install nginx
apt install nginx -y

# Get instance details dynamically
PRIVATE_IP=$(hostname -I | awk '{print $1}')
HOSTNAME=$(hostname)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Create the HTML page
cat <<EOF > /var/www/html/index.html
<html>
<head>
    <title>Private Server</title>
</head>
<body style="font-family: Arial; text-align: center; margin-top: 50px;">
    <h1 style="color: green;">Welcome to the Private Server</h1>

    <h2>Private IP: $PRIVATE_IP</h2>
    <h2>Hostname: $HOSTNAME</h2>
    <h3>Availability Zone: $AZ</h3>

    <hr>

    <p>This page is served from your private subnet EC2 instance.</p>
</body>
</html>
EOF

# Enable NGINX
systemctl enable nginx
systemctl restart nginx
