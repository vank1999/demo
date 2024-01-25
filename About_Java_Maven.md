Application:
  - Src Code
    - Java / Python / .net / R
  - Infra As Code
    - Ansible / Docker / K8s / Shell / Python

Java App:
  - Web Apps
  - Different Editions
    - J2SE
      - Standard Edition (Src Code)
      - Multi Threading Apps / Applet / Swing
      - Artifact (.jar)
      - Deployment: JVM
    - J2EE
      - Enterprise Edition (Src Code)
      - Web Apps / Business trxs / Messaging Systems
      - Artifact (.war / .jar / .ear / .rar)
      - Deployment: Tomcat / JBoss / WL / WAS

Build Process:
  - Src Code -> compile -> Package (archive)   -> Deploy to Servers / JVM
      .java  ->  .class -> .jar / .war / .ear  -> Tomcat / JBoss/ WL / WAS

Build Tool:
  - Src Code -> compile -> Unit Test cases -> Package (archive)
  - Maven / Ant / Gradle

Maven Build Tool:
  - Open Source
  - Apache Vendor
  - Platform Independent
  - Automate build process

Maven:
  - Install Softwares
    - Java
    - Maven
    - Git
  - Sample Java App
    - Src Code (GitHub)
      - Compile
        - $ mvn clean compile
      - Unit Tests
        - $ mvn clean test
        - target/surefire-reports/*.xml
      - Package App (.jar / .war / .ear)
        - $ mvn clean package
        - target/*.jar
      - Distribution
        - uploading Artifact to the Repo (Nexus / JFrog)

Maven Commands:
  - mvn -version
  - mvn compile
  - mvn clean
  - mvn clean compile
  - mvn clean test
  - mvn clean package

Deployment to Servers: (Hosting of Java App)
  - Install
  - Start/Stop/restart
  - Deploy/Hosting the App

  Types of Servers:
    - 2 Types
      - Web Servers
        - Static Content Application
        - Ex:
          - Apache Httpd
          - Nginx
          - MS IIS
          - OHS
          - IHS

      - Application Servers
        - Static or Dynamic
        - Java App
          - Tomcat
          - WL
          - WAS
          - JBoss
        - .net
          - IIS

  - Apache Web Server (httpd): Static Content Application
    - yum install httpd -y
    - systemctl start/stop/restart httpd
    - /var/www/html/
    - URL

  - Apache Tomcat App Server: Java Application (Static and Dynamic)
    - Install Java
      - sudo yum install java11 -y
    - Install Tomcat
      - cd /opt
      - wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.85/bin/apache-tomcat-9.0.85.tar.gz
      - Extract it
      - Rename the Dir ($TOMCAT_HOME)
    - Start and Stop the Server
      - Version of the Tomcat Server
        - $TOMCAT_HOME/bin
        - ./version.sh

      - Starting Tomcat Server
        - $TOMCAT_HOME/bin
          - ./startup.sh

      - Verify the Server Status
        - $ netstat -nltp
        - $ ps -ef | grep tomcat
        - URL: http://IP:8080
        - http://192.168.33.10:8080/

      - Stopping the Tomcat Server
        - $TOMCAT_HOME/bin
          - ./shutdown.sh

      - Deployment of Application (Java)
        - $TOMCAT_HOME/webapps

      - Access the manager's App
        - http://192.168.33.10:8080/manager
        - Remove local address access
          - $TOMCAT_HOME/webapps/manager/META-INF
          - vi context.xml
              <!-- <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->

        - Adding users to access manager's app
          - $TOMCAT_HOME/conf/tomcat-users.xml
            - <role rolename="manager-gui"/>
              <user username="tomcat" password="s3cret" roles="manager-gui"/>

          - Restart the Tomcat Server
            - $TOMCAT_HOME/bin
              - ./shutdown.sh
              - ./startup.sh

      - Deployment of Application (Java)

      - Two ways of Deployment
        - 1. Manager's App (GUI)
        - 2. Hot Deployment
          - $TOMCAT_HOME/webapps/

      - Change the port Number of the Tomcat Server
        - $TOMCAT_HOME/conf
        - vi server.xml
        - Restart the Tomcat server



Service Management:
  - Ex: Httpd / SSH / nginx / network / firewalld
    - sudo systemctl start/stop/restart/enable/ service_name
    - sudo systemctl start tomcat

Register the Tomcat as Service:
  - sudo vi /etc/systemd/system/tomcat.service
        [Unit]
        Description=Tomcat Server
        After=syslog.target network.target

        [Service]
        Type=forking
        User=vagrant
        Group=vagrant

        Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.13.0.8-4.el8_5.x86_64
        Environment='JAVA_OPTS=-Djava.awt.headless=true'
        Environment=CATALINA_HOME=/opt/appserver/
        Environment=CATALINA_BASE=/opt/appserver/
        Environment=CATALINA_PID=/opt/appserver/temp/tomcat.pid
        Environment='CATALINA_OPTS=-Xms512M -Xmx512M'
        ExecStart=/opt/appserver/bin/catalina.sh start
        ExecStop=/opt/appserver/bin/catalina.sh stop

        [Install]
        WantedBy=multi-user.target

    - sudo systemctl daemon-reload
    - sudo systemctl start tomcat
    - sudo systemctl enable tomcat
    - sudo systemctl stop tomcat



Nginx Web Server:

Features:
  - Hosting Static content Application
  - Reverse Proxy Configuration (forward req to backend Layer)
    - Security / Firewall
    - Static Hosting
    - Load Distribution (Session Stickyness)

Nginx as Web Server:
  - Install
  - Start/Stop
  - Deployment of App
  - Configuration

  - Install Nginx
    - $ sudo yum search nginx
      $ sudo yum install nginx.x86_64 -y

  - Start and Stop Nginx:
    -  sudo systemctl start nginx
    -  netstat -nltp
    -  sudo systemctl enable nginx
    -  ps -ef | grep nginx
    -  sudo systemctl stop firewalld.service
    -  hostname -I
    -  netstat -nltp

Deployment:
    Apache Httpd: /var/www/html
    Tomcat Server: $TOMCAT_HOME/webapps
    Nginx Server: /usr/share/nginx/html/

Static Application Hosting on Nginx:

      cd
      netstat -nltp
      47  hostname -I
      48  git clone https://gitlab.com/rns-app/static-project.git
      49  ll
      50  cd static-project/
      51  ll
      52  cd iPortfolio/
      53  ll
      54  cd /usr/share/nginx/html/
      55  ll
      57  sudo rm -rf *
      58  ll
      59  pwd
      sudo cp -R ~/static-project/iPortfolio/* .
      URL: http://IP:80

Nginx as Reverse Proxy Server:


    Go to /etc/nginx/nginx.conf
      in the server block
      server {
          listen       80 default_server;
          listen       [::]:80 default_server;
          server_name  _;
          root         /usr/share/nginx/html;

          # Load configuration files for the default server block.
          include /etc/nginx/default.d/*.conf;

          location / {
          }

          location /webapp {
            proxy_pass http://192.168.33.10:8080/webapp;
          }

          error_page 404 /404.html;
              location = /40x.html {
          }

          error_page 500 502 503 504 /50x.html;
              location = /50x.html {
          }
      }

      Restart the Nginx:
        sudo systemctl stop/start nginx
        $ sudo systemctl status nginx
        $ nginx -t
        $ tail -100f /var/log/nginx/error.log


Deploy Dynamic App:


        git clone https://gitlab.com/rns-app/student-app.git
        47  ll
        48  cd student-app/
        49  ll
        50  mvn clean package
        51  java -version
        52  sudo alternatives --config java
        53  sudo yum search java
        54  sudo yum install java-1.8.0-openjdk-devel.x86_64 -y
        55  sudo alternatives --config java
        56  java -version
        57  mvn clean package
        58  ll target/
        59  sudo alternatives --config java
        60  cp target/studentapp-1.0.war /opt/appserver/webapps/student.war
        61  cd /etc/nginx/
        62  sudo vi nginx.conf


        location /webapp {
            proxy_pass http://192.168.33.10:8080/webapp;
        }

        location /student {
            proxy_pass http://192.168.33.10:8080/student;
        }

        63  nginx -t
        64  sudo systemctl stop nginx
        65  sudo systemctl start nginx
        66  sudo systemctl status nginx

Setup Maria DB:
----------------

      sudo yum search mariadb
      70  sudo yum install mariadb-server.x86_64 -y
      77  sudo systemctl start mariadb.service
      78  sudo systemctl enable mariadb.service
      79  sudo systemctl status mariadb.service
      80  netstat -nltp
      82  mysql -uroot

          show databases;
          use dbname;
          show tables;
          select * from table_name;
          exit;

      83  cd ~
      84  cd student-app/
      85  ll
      86  ll dbscript/
      87  cat dbscript/studentapp.sql
      88  mysql -uroot < dbscript/studentapp.sql
      mysql -ustudent -pstudent1

          show databases;
          use studentapp;
          show tables;
          select * from students;
          exit;

Integration of AppServer with Mariadb:

    - netstat -nltp
    - cd ~/student-app/tomcat/conf/
    - cp context.xml /opt/appserver/conf/
    - sudo systemctl stop tomcat.service
    - sudo systemctl start tomcat.service
    - netstat -nltp
      - URL: http://192.168.33.10/student
      - http://192.168.33.10/student/viewStudents
    - cd /opt/appserver/logs/
    - tail -f catalina.out

    - ll ~/student-app/tomcat/lib/
    - cp ~/student-app/tomcat/lib/mysql-connector.jar /opt/appserver/lib/
    - sudo systemctl stop tomcat
    - sudo systemctl start tomcat
    - mysql -ustudent -pstudent1
      - use studentapp;
      - select * from students;
