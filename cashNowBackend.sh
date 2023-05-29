#!/bin/bash
# updates
sudo apt-get update
sudo apt-get install -y build-essential openssl libssl-dev pkg-config

#Node.js Setup:

sudo apt-get install -y build-essential openssl libssl-dev pkg-config
sudo apt-get install -y nodejs nodejs-legacy 
sudo apt-get install npm -y
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
sudo apt-get install nginx git -y

# Clone the repository
cd /var/www
sudo git clone https://github.com/viveksinra/cashNowBackend.git
# SetUp Nginx:

# Move to the project directory
cd cashNowBackend
sudo apt-get install -y build-essential openssl libssl-dev pkg-config
cd /etc/nginx/sites-available
# adding Vim
sudo bash -c "cat > /etc/nginx/sites-available/cashNowBackend" <<EOL
server {
    listen 80;
    location / {
        proxy_pass http://172.31.11.75:2040;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL
sudo rm default
# Create a symbolic link from sites-enabled to sites-available:
sudo ln -s /etc/nginx/sites-available/cashNowBackend /etc/nginx/sites-enabled/cashNowBackend

# Remove the default from nginx’s sites-enabled diretory:
sudo rm /etc/nginx/sites-enabled/default
Installing pm2 and updating project dependencies:
sudo npm install pm2 -g
cd /var/www/
sudo chown -R ubuntu cashNowBackend
cd cashNowBackend
sudo npm install


# Install project dependencies
sudo npm install
pm2 start server.js
sudo service nginx stop && sudo service nginx start
pm2 restart server.js