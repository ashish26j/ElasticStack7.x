echo "After installation of ELK, reloading service\n"
sudo /bin/systemctl daemon-reload
printf "=======================================\n"

echo "Enabling and Starting: kibana"
sudo /bin/systemctl enable kibana.service
sudo systemctl start kibana.service
sudo systemctl status kibana.service
printf "=======================================\n"


echo "sleeping for 20 sec as ELK Services take time get fully responsive"
sudo sleep 20
printf "=======================================\n"


echo "Setting UP Nginx for frontaging Kibana"
printf "=======================================\n"
pubinterface="enp0s8"

kibanaPort="8010"

installNginx="NO"

if [ $installNginx == "YES" ]; then
  sudo yum install -y epel-release
  sudo yum install -y nginx
  sudo systemctl enable nginx
  sudo systemctl start nginx
  sudo systemctl status nginx
  echo "kibanaadmin:`openssl passwd -apr1`" | sudo tee -a /etc/nginx/htpasswd.users
else
  echo "Install Flag: OFF"
fi


nginxIP=$(ip addr show $pubinterface | grep  -w inet |awk '{print $2}'| awk -F"/" '{print $1}')
echo $nginxIP

cat <<EOF | sudo tee /etc/nginx/conf.d/kibana_${kibanaPort}.conf
server {
    listen ${kibanaPort};

    server_name ${nginxIP};

    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.users;

    location / {
        proxy_pass http://localhost:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

cat /etc/nginx/conf.d/kibana.conf
nginx -t

sudo systemctl restart nginx
sudo systemctl status nginx
echo "Try kibana with URL: curl http://${nginxIP}):${kibanaPort}"
