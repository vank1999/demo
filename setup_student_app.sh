#! /bin/bash

# sudo yum update -y
sudo systemctl stop firewalld
# sudo setsebool httpd_can_network_connect 1

sudo hostnamectl set-hostname app-server

# add the user devops
sudo useradd devops

# set password : the below command will avoid re entering the password
echo "devops" | passwd --stdin devops

# modify the sudoers file at /etc/sudoers and add entry
echo 'devops     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers

# this command is to add an entry to file : echo 'PasswordAuthentication yes' | sudo tee -a /etc/ssh/sshd_config
# the below sed command will find and replace words with spaces "PasswordAuthentication no" to "PasswordAuthentication yes"
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service sshd restart

# sudo yum install tree wget zip unzip gzip vim net-tools git bind-utils python2-pip jq -y

sudo su - devops -c "git config --global user.name 'devops'"
sudo su - devops -c "git config --global user.email 'devops@gmail.com'"

# Installing Java 11
#sudo yum install java-11-openjdk-devel.x86_64 -y

sudo chown -R devops:devops /opt

cd /opt

wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
tar -xzvf apache-maven-3.9.6-bin.tar.gz
mv apache-maven-3.9.6 maven
rm -rf apache-maven-3.9.6-bin.tar.gz
sudo su - devops -c "ln -s /opt/maven/bin/mvn /usr/local/bin/mvn"

wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.85/bin/apache-tomcat-9.0.85.tar.gz
tar -xzvf apache-tomcat-9.0.85.tar.gz
rm -rf apache-tomcat-9.0.85.tar.gz
mv apache-tomcat-9.0.85 appserver

echo '[Unit]
        Description=Tomcat Server
        After=syslog.target network.target

        [Service]
        Type=forking
        User=devops
        Group=devops

        Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.13.0.8-4.el8_5.x86_64
        Environment='JAVA_OPTS=-Djava.awt.headless=true'
        Environment=CATALINA_HOME=/opt/appserver/
        Environment=CATALINA_BASE=/opt/appserver/
        Environment=CATALINA_PID=/opt/appserver/temp/tomcat.pid
        Environment='CATALINA_OPTS=-Xms512M -Xmx512M'
        ExecStart=/opt/appserver/bin/catalina.sh start
        ExecStop=/opt/appserver/bin/catalina.sh stop

        [Install]
        WantedBy=multi-user.target' > /etc/systemd/system/tomcat.service

systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

# Setup Nginx

sudo yum install nginx.x86_64 -y
systemctl enable nginx
systemctl start nginx

# Setup Maria DB

sudo yum install mariadb-server.x86_64 -y
systemctl enable mariadb
systemctl start mariadb
# systemctl status mariadb

git clone https://gitlab.com/rns-app/student-app.git
