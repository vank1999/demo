#! /bin/bash

cd /opt/

#git clone https://gitlab.com/rns-app/student-app.git

mysql -uroot < /opt/student-app/dbscript/studentapp.sql

# Manager's App Context XML

cp /opt/student-app/tomcat/manager/context.xml /opt/appserver/webapps/manager/META-INF

# Add User to Tomcat

cp /opt/student-app/tomcat/conf/tomcat-users.xml /opt/appserver/conf/

# Load DB Driver

cp /opt/student-app/tomcat/lib/mysql-connector.jar /opt/appserver/lib/

# Integrate Tomcat with DB

cp /opt/student-app/tomcat/conf/context.xml /opt/appserver/conf/

# Restart the Tomcat SErvice

sudo systemctl stop tomcat
sudo systemctl start tomcat

# Deploying Student App

sudo yum install java-1.8.0-openjdk-devel.x86_64 -y

cd /opt/student-app/
git pull origin main

echo 2 | sudo alternatives --config java

mvn clean package

echo '1' | sudo alternatives --config java

cp /opt/student-app/target/*.war /opt/appserver/webapps/student.war
