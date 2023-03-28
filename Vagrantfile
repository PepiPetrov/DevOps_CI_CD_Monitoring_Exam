# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    
  config.ssh.insert_key = false

  config.vm.define "monitoring" do |monitoring|
    monitoring.vm.box="shekeriev/debian-11"
    monitoring.vm.hostname = "monitoring.do1.exam"
    monitoring.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096"]
    end
    monitoring.vm.network "private_network", ip: "192.168.99.100"
    monitoring.vm.network "forwarded_port", guest: 5601, host: 8082
    monitoring.vm.provision "shell", path: "provision-scripts/add_hosts.sh"
    monitoring.vm.provision "shell", path: "provision-scripts/install_elastic_stack.sh"
    monitoring.vm.synced_folder "shared-files/", "/vagrant"
  end
  
  config.vm.define "docker" do |docker|
    docker.vm.box = "shekeriev/debian-11"
    docker.vm.hostname = "containers.do1.exam"
    docker.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096"]
    end
    docker.vm.network "private_network", ip: "192.168.99.102"
    docker.vm.network "forwarded_port", guest: 8080, host: 8081
    docker.vm.provision "shell", path: "provision-scripts/add_hosts.sh"
    docker.vm.provision "shell", path: "provision-scripts/install_docker.sh"
    docker.vm.provision "shell", path: "provision-scripts/install_metricbeat.sh"
    docker.vm.provision "shell", path: "provision-scripts/setup_gitea.sh"
    docker.vm.provision "shell", path: "provision-scripts/metricbeat_docker_data.sh"
    docker.vm.synced_folder "shared-files/", "/vagrant"
  end
  
  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box="shekeriev/debian-11"
    jenkins.vm.hostname = "pipelines.do1.exam"
    jenkins.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096"]
    end
    jenkins.vm.network "private_network", ip: "192.168.99.101"
    jenkins.vm.network "forwarded_port", guest: 8080, host: 8080
    jenkins.vm.provision "shell", path: "provision-scripts/add_hosts.sh"
    jenkins.vm.provision "shell", path: "provision-scripts/install_jenkins.sh"
    jenkins.vm.provision "shell", path: "provision-scripts/setup_jenkins.sh"
    jenkins.vm.provision "shell", path: "provision-scripts/install_metricbeat.sh"
    jenkins.vm.synced_folder "shared-files/", "/vagrant"
  end
  
end
  