cp /vagrant/monitoring/docker.yml /etc/metricbeat/modules.d/docker.yml
metricbeat modules enable docker

systemctl daemon-reload
systemctl restart metricbeat