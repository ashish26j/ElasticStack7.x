
logstash_host="localhost"
yum install -y filebeat

/etc/filebeat/filebeat.yml

cat <<EOF | sudo tee /etc/filebeat/filebeat.yml

filebeat.inputs:

- type: log
  enabled: false
  paths:
    - /var/log/*.log


filebeat.config.modules:
  path: \${path.config}/modules.d/*.yml
  reload.enabled: false


setup.template.settings:
  index.number_of_shards: 1

setup.kibana:

output.logstash:
  hosts: ["${logstash_host}:5044"]


processors:
  - add_host_metadata: ~
  - add_cloud_metadata: ~


EOF

sudo filebeat modules enable system
sudo filebeat modules list

sudo filebeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'

sudo systemctl start filebeat
sudo systemctl enable filebeat


curl -X GET 'http://localhost:9200/filebeat-*/_search?pretty'
