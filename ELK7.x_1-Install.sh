
install="NO"

if [ $install = "YES" ]; then
  sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
  cat <<EOF | sudo tee /etc/yum.repos.d/elk-7x.repo
[elk-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

  sudo yum clean all
  sudo yum makecache
  sudo yum install -y elasticsearch
  sudo yum install -y logstash
  sudo yum install -y kibana
fi
