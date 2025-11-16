#!/bin/bash

# ----------------------------------------
# Install NGINX
# ----------------------------------------
sudo apt update -y
sudo apt install nginx -y

# Enable + Start service
sudo systemctl enable nginx
sudo systemctl start nginx

# ----------------------------------------
# Create Custom Homepage
# ----------------------------------------
sudo rm -f /var/www/html/index.nginx-debian.html

sudo tee /var/www/html/index.html > /dev/null << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Welcome to My Server</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background: linear-gradient(135deg, #4A90E2, #50E3C2);
        height: 100vh;
        margin: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        color: white;
        text-shadow: 1px 1px 3px rgba(0,0,0,0.4);
    }
    .container {
        text-align: center;
        padding: 40px;
        background: rgba(255,255,255,0.12);
        border-radius: 15px;
        backdrop-filter: blur(4px);
    }
    h1 {
        font-size: 48px;
        margin-bottom: 10px;
        font-weight: 800;
    }
    p {
        font-size: 20px;
        margin-top: 5px;
        opacity: 0.9;
    }
</style>
</head>
<body>
<div class="container">
    <h1>Welcome to My NGINX Server 🚀</h1>
    <p>Your server is successfully running on Ubuntu 22.</p>
    <p>Deployment done via automation script.</p>
</div>
</body>
</html>
EOF

# ----------------------------------------
# Restart NGINX
# ----------------------------------------
sudo systemctl restart nginx

echo "------------------------------------"
echo "NGINX installed and homepage created!"
echo "Visit your server's IP to check."
echo "------------------------------------"




-----------------------------------------------------------------
#!/bin/bash

# ----------------------------------------
# Install NGINX
# ----------------------------------------
sudo apt update -y
sudo apt install nginx -y

# Enable + Start service
sudo systemctl enable nginx
sudo systemctl start nginx

# ----------------------------------------
# Create Custom Homepage
# ----------------------------------------
sudo rm -f /var/www/html/index.nginx-debian.html

sudo tee /var/www/html/index.html > /dev/null << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Server 2 - Neon Dashboard</title>
<style>
    body {
        margin: 0;
        height: 100vh;
        background: #0a0a0a;
        font-family: 'Segoe UI', sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        color: #fff;
    }
    .box {
        padding: 40px 60px;
        border-radius: 12px;
        background: rgba(255,255,255,0.04);
        border: 1px solid rgba(255,255,255,0.1);
        box-shadow: 0px 0px 40px rgba(0,200,255,0.25);
        text-align: center;
    }
    h1 {
        font-size: 46px;
        color: #00eaff;
        text-shadow: 0 0 15px rgba(0, 234, 255, 0.8);
        margin-bottom: 10px;
    }
    p {
        font-size: 18px;
        opacity: 0.85;
        margin: 6px 0;
    }
    .tag {
        margin-top: 20px;
        display: inline-block;
        padding: 8px 18px;
        background: rgba(0, 234, 255, 0.15);
        border: 1px solid #00eaff;
        border-radius: 20px;
        font-size: 14px;
        letter-spacing: 1px;
        text-transform: uppercase;
    }
</style>
</head>
<body>
<div class="box">
    <h1>Server 1 — Online</h1>
    <p>Your Ubuntu 22 NGINX server is running.</p>
    <p>Neon UI theme applied for identification.</p>
    <span class="tag">NEON MODE ACTIVE</span>
</div>
</body>
</html>
EOF

# ----------------------------------------
# Restart NGINX
# ----------------------------------------
sudo systemctl restart nginx

echo "------------------------------------"
echo "NGINX installed and neon homepage created!"
echo "Visit the server's IP to see the new UI."
echo "------------------------------------"
