#!/bin/bash

wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.6.2-amd64.deb
dpkg -i metricbeat-8.6.2-amd64.deb
rm *.deb

cp /vagrant/monitoring/metricbeat.yml /etc/metricbeat/metricbeat.yml
metricbeat modules enable system

metricbeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["192.168.99.100:9200"]'

metricbeat modules disable beat
metricbeat modules disable logstash

cp /vagrant/monitoring/metricbeat.yml /etc/metricbeat/metricbeat.yml

systemctl daemon-reload
systemctl enable metricbeat
systemctl start metricbeat
