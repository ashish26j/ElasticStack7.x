
echo "After installation of ELK, reloading service\n"
sudo /bin/systemctl daemon-reload
printf "=======================================\n"

echo "Enabling and Starting: Elasticsearch\n"
sudo /bin/systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
sudo systemctl status elasticsearch.service
printf "=======================================\n"

echo "sleeping for 20 sec as ELK Services take time get fully responsive"
sudo sleep 20
printf "======================================="

echo "Testing Elasticsearch"
curl http://127.0.0.1:9200
printf "=======================================\n"
