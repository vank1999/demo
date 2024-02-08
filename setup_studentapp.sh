#! /bin/bash

sudo setsebool -P httpd_can_network_connect 1

cd /opt/student-app

git pull origin main

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

cd /opt/student-app/


echo 2 | sudo alternatives --config java

sudo su - devops -c "mvn clean package"

echo '1' | sudo alternatives --config java

cp /opt/student-app/target/*.war /opt/appserver/webapps/student.war

# Nginx static app deployment

cd /usr/share/nginx/html/

sudo rm -rf *

cd /opt/


cd static-project/iPortfolio/

sudo cp -R /opt/static-project/iPortfolio/* /usr/share/nginx/html/


# Reverse Proxy Configuration

sudo cp /opt/student-app/nginx/nginx.conf /etc/nginx/

sudo systemctl stop nginx
sudo systemctl start nginx
