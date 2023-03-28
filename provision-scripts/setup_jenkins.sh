#!/bin/bash

# Change these two (remove the <> as well)
CRED_NAME=22072010sv
CRED_PASS=dckr_pat_3Wdll1BMk2Ul4SZY0JD_uCd2Gvg

echo "* Stop Jenkins"
systemctl stop jenkins

echo "* Turn off setup wizard"
sed -i 's/# arguments to pass to java/JAVA_OPTS="-Djenkins.install.runSetupWizard=false"/' /etc/default/jenkins

echo "* Upload Groovy scripts"
mkdir /var/lib/jenkins/init.groovy.d
cp /vagrant/jenkins/*.groovy /var/lib/jenkins/init.groovy.d/
chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d/

echo "* Start Jenkins" 
systemctl start jenkins

echo "* Download Jenkins Plugin Manager" 
wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.9/jenkins-plugin-manager-2.12.9.jar

echo "* Install Plugins" 
java -jar jenkins-plugin-manager-*.jar --war /usr/share/java/jenkins.war --plugin-file /vagrant/jenkins/plugins.txt -d /var/lib/jenkins/plugins --verbose

echo "* Restart Jenkins" 
systemctl restart jenkins

echo "* Download Jenkins CLI"
wget http://192.168.99.101:8080/jnlpJars/jenkins-cli.jar

echo "* Create vagrant credentials"
/vagrant/jenkins/add-jenkins-credentials.sh vagrant vagrant vagrant

echo "* Create Docker Hub credentials"
/vagrant/jenkins/add-jenkins-credentials.sh docker-hub $CRED_NAME $CRED_PASS

echo "* Add slave node"
/vagrant/jenkins/add-jenkins-slave.sh containers.do1.exam vagrant

echo "* Add the exam job"
/vagrant/jenkins/add-jenkins-job.sh

sleep 10
java -jar /home/vagrant/jenkins-cli.jar -s http://192.168.99.101:8080/ -http -auth admin:admin build exam