#!/bin/sh

domain_name="assafdori.com"
email_addr="assafxdori@gmail.com"

# Start Certbot for initial certificate provisioning
certbot certonly --webroot -w /usr/share/nginx/html -d "${domain_name}" --agree-tos --email "${email_addr}"

# Start NGINX
nginx

# Automatically renew certificates
while :
do
    certbot renew
    sleep 12h & wait $!
done
