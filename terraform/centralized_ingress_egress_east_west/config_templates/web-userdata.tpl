#! /bin/bash
sleep 300
sudo apt update
sudo apt -y upgrade
sudo apt -y install sysstat
sudo apt -y install net-tools
sudo apt -y install iperf3
sudo apt -y install apache2
sudo apt -y install lnav
sudo ufw allow 'Apache'
sudo sed -i 's/It works!/It works for ${region}${availability_zone}!/' /var/www/html/index.html
sudo systemctl start apache2
sudo apt -y install unzip
echo 'Welcome to ${region}${availability_zone} Fortigate CNF Workshop Demo' > /var/www/html/demo.txt
echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*%' > /var/www/html/eicar.com.txt
cd /var/www/html
sudo sed -i 's/^#module(load="immark")/module(load="immark")/' /etc/rsyslog.conf
sudo sed -i 's/^#module(load="imudp")/module(load="imudp")/' /etc/rsyslog.conf
sudo sed -i 's/^#input(type="imudp" port="514")/input(type="imudp" port="514")/' /etc/rsyslog.conf
sudo service rsyslog restart


