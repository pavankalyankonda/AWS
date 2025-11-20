#!/bin/bash
PRIVATE_IP=$(hostname -I | awk '{print $1}')
Public_IP=$(curl ifconfig.me)

cat <<EOF > /var/www/html/index.html
<html>
<head><title>Server</title></head>
<body style='font-family: Arial; text-align: center; margin-top: 50px;'>
<h1 style='color: green;'>Welcome to Nginx Web Server</h1>
<h2>Server Private IP: $PRIVATE_IP</h2>
<h2>Server Public  IP: $Public_IP</h2>
<hr>
<p>This page is served from the private subnet.</p>
</body>
</html>
EOF