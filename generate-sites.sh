#!/bin/bash
STATUSCOLOR='\033[1;96m'
NC='\033[0m'

docker container ps --format "{{.Names}}" --filter "name=nginx" > teste
echo "Deletando sites cadastrados"
rm -rf docker/sites-avaliable/*.conf

echo -ne "populando sites-enable com serviços inicializados"
sleep 1
echo -ne " ..."

headerHost='proxy_set_header Host $host;'
host='$host';

rm -rf www/index.html
urls='';

echo "  #default server
  server {
    listen 80 default_server;
    server_name _;
    error_page 404 /error-pages/404.html;

    location / {
        return 404;
    }
    location /error-pages/ {
        root /var/www/;
    }
  }
  #localhost
  server {
    listen 80;
    server_name localhost;
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
  }" >> docker/sites-avaliable/default.conf

while IFS= read -r line; do
  if [ $line = "nginx" ]
  then
    continue
    fi

  urls+="<li><a href='http://${line/_nginx/}.localhost' target="_blank">→ ${line/_nginx/}.localhost</a></li>";
  echo "  #${line/_nginx/}.localhost;
  server {
    proxy_read_timeout 300;
    proxy_connect_timeout 300;
    proxy_send_timeout 300;
    client_max_body_size 0;

    listen 80;
    server_name ${line/_nginx/}.localhost;
    access_log  /var/log/nginx/proxy.access.log;

    location / {
        proxy_pass http://${line/_nginx/}.localhost;
        $headerHost
    }
  }" >> docker/sites-avaliable/default.conf
done < teste

sed "s!URLS!${urls}!ig" error-pages/404.html.example > error-pages/404.html

echo -e " ${STATUSCOLOR}done${NC}"

rm -rf teste
docker compose restart nginx