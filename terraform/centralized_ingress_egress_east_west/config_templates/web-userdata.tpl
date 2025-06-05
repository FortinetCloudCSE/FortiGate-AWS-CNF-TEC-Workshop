#! /bin/bash
sudo apt update
sudo apt -y upgrade
sudo apt -y install sysstat
sudo apt -y install net-tools
sudo apt -y install iperf3
sudo apt -y install apache2
sudo apt -y install lnav
sudo ufw allow 'Apache'
sudo mkdir /tmp/cert
sudo openssl req  -nodes -new -x509  -days 365 -keyout /tmp/cert/server.key -out /tmp/cert/server.crt -subj "/C=US/ST=Texas/L=McKinney/O=Fortinet/OU=CNF/CN=www.fortimdw.com"
sudo mv /tmp/cert/server.crt /etc/ssl/certs/server.crt
sudo mv /tmp/cert/server.key /etc/ssl/private/server.key
sudo sed -i 's#/etc/ssl/certs/ssl-cert-snakeoil.pem#/etc/ssl/certs/server.crt#' /etc/apache2/sites-available/default-ssl.conf
sudo sed -i 's#/etc/ssl/private/ssl-cert-snakeoil.key#/etc/ssl/private/server.key#' /etc/apache2/sites-available/default-ssl.conf
sudo a2ensite default-ssl.conf
sudo a2enmod ssl
sudo sed -i 's/It works!/It works for ${region}${availability_zone}!/' /var/www/html/index.html
sudo systemctl enable apache2
sudo systemctl restart apache2
sudo apt -y install unzip
echo "Welcome to ${region}${availability_zone} Fortigate CNF Workshop Demo" > /var/www/html/demo.txt
cd /var/www/html
sudo sed -i 's/^#module(load="immark")/module(load="immark")/' /etc/rsyslog.conf
sudo sed -i 's/^#module(load="imudp")/module(load="imudp")/' /etc/rsyslog.conf
sudo sed -i 's/^#input(type="imudp" port="514")/input(type="imudp" port="514")/' /etc/rsyslog.conf
sudo service rsyslog restart
echo 'Welcome to ${region}${availability_zone} Fortigate CNF Workshop Demo' > /var/www/html/demo.txt
echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*%' > /var/www/html/eicar.com.txt



