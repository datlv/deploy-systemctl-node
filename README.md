# deploy-systemctl-node
- Get certificate from a ssl certificate organization
    - gen rsa
    - openssl req -new -newkey rsa:2048 -nodes -out star_deevo_io.csr -keyout star_deevo_io.key -subj "/C=SG/ST=Singapore/L=Singapore/O=DEEVO TECH PTE. LTD./OU=Software Development/CN=*.deevo.io"
- sent to certifiate organization, and get files
    - your_domain.csr
    - bundle.crt
Run command
- cat your_domain.csr bundle.crt > bundle.chain.crt
Nginx config
    - ssl key to server.key
    - ssl certificate bundle.chain.crt
    - ssl_protocols TLSv1 TLSv1.1 TLSv1.2; 
    - ssl_prefer_server_ciphers on;
    - ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
Apache config 
    - SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
    - SSLHonorCipherOrder on