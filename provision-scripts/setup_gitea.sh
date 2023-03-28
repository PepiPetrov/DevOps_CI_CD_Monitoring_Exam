#!/bin/bash

# Start Gitea
docker compose -f /vagrant/docker/docker-compose.yml up -d

# Wait until ready
while true; do 
  echo 'Trying to connect to http://192.168.99.102:3000 ...'; 
  if [ $(curl -s -o /dev/null -w "%{http_code}" http://192.168.99.102:3000) == "200" ]; then 
    echo '... connected.'; 
    break; 
  else 
    echo '... no success. Sleep for 5s and retry.'; 
    sleep 5; 
  fi 
done

# Add user
docker container exec -u 1000 gitea gitea admin user create --username vagrant --password vagrant --email vagrant@do1.exam

# Clone the project
git clone https://github.com/shekeriev/fun-facts /tmp/exam

# Modify the repository
echo "Modified on $(date '+%Y-%m-%d %H:%M:%S')" >> /tmp/exam/README.md
cd /tmp/exam && git add . && git commit -m "Modified on $(date '+%Y-%m-%d %H:%M:%S')"

# Add it to Gitea (but as public repository)
cd /tmp/exam && git push -o repo.private=false http://vagrant:vagrant@192.168.99.102:3000/vagrant/exam

rm -rf /tmp/exam/

# Add a Webhook
curl -X 'POST' 'http://192.168.99.102:3000/api/v1/repos/vagrant/exam/hooks' \
  -H 'accept: application/json' \
  -H 'authorization: Basic '$(echo -n 'vagrant:vagrant' | base64) \
  -H 'Content-Type: application/json' \
  -d '{
  "active": true,
  "branch_filter": "**",
  "config": {
    "content_type": "json",
    "url": "http://192.168.99.101:8080/gitea-webhook/post",
    "http_method": "post"
  },
  "events": [
    "push"
  ],
  "type": "gitea"
}'
