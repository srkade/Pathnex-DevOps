#!/bin/bash
# Day 2: EC2 User Data script (runs on first launch)

# Update system
apt update -y
apt upgrade -y

# Install nginx and git
apt install nginx git -y

# Start and enable nginx
systemctl start nginx
systemctl enable nginx

# Create a sample index page
cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>DevOps Linux Server</title>
</head>
<body style="font-family: Arial, sans-serif; text-align: center; padding-top: 50px;">
    <h1>DevOps AWS EC2 Server is Live!</h1>
    <p>Setup on Day 2: Linux commands, Permissions & AWS EC2</p>
</body>
</html>
EOF

# Ensure web permissions
chmod 644 /var/www/html/index.html
chown www-data:www-data /var/www/html/index.html
