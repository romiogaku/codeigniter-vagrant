#!/usr/bin/env bash

PROJECTNAME="projectname"
MYSQLPASS="pass"

echo "Installing Apache etc..."

apt-get update >/dev/null 2>&1

echo mysql-server-5.5 mysql-server/root_password password $MYSQLPASS | debconf-set-selections
echo mysql-server-5.5 mysql-server/root_password_again password $MYSQLPASS | debconf-set-selections

apt-get install -y apache2 php5 mysql-server php5-mysql vim unzip >/dev/null 2>&1

/etc/init.d/apache2 restart

a2enmod rewrite

cd /vagrant

# CodeIgniter
echo "Installing CodeIgniter"
wget -O ci.zip http://codeigniter.com/download.php >/dev/null 2>&1

cat <<EOT >>vhost.conf
<VirtualHost *:80>
  ServerName $PROJECTNAME.excite.co.jp
  DocumentRoot /vagrant/$PROJECTNAME.excite.co.jp
    <Directory "/vagrant/$PROJECTNAME.excite.co.jp">
      Options FollowSymLinks Includes
      AllowOverride All
      Order allow,deny
      Allow from all
    </Directory>
</VirtualHost>
EOT
unzip ci.zip -d $PROJECTNAME.excite.co.jp >/dev/null 2>&1
rm -rf ci.zip

sudo cp /vagrant/vhost.conf /etc/apache2/sites-available/vhost.conf
sudo a2ensite vhost.conf
rm -rf vhost.conf
sudo service apache2 reload

echo "Complete!"