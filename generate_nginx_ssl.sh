#!/bin/bash
sudo mkdir /etc/nginx/ssl
cd /etc/nginx/ssl
sudo openssl genrsa -des3 -out server.key 2048
sudo openssl req -new -key server.key -out server.csr
# remove passphrase
sudo cp server.key server.key.org
sudo openssl rsa -in server.key.org -out server.key
sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
# set up cerficate 
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/example
sudo nano /etc/nginx/sites-available/example
# HTTPS server

echo "server {
    listen 80;
    server_name localhost;

    # redirects both www and non-www to ssl port with http (NOT HTTPS, forcing error 497)
    return 301 https://localhost$request_uri;
}

server {
    listen 433 ssl http2 default_server;
    listen [::]:443 ssl http2 default_server;

    server_name localhost;
    error_page 497 https://localhost$request_uri;

    #include snippets/ssl-domain.com.conf;
    #include snippets/ssl-params.conf;
    ssl on;
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;

    # other vhost configuration
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}";
# active server
sudo ln -s /etc/nginx/sites-available/example /etc/nginx/sites-enabled/example
# start server
sudo service nginx restart