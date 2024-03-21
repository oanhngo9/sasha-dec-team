#!/bin/bash
apt-get update
apt-get install -y apache2 php libapache2-mod-php mariadb-client php-mysql wget unzip
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
cp -R wordpress/* /var/www/html/
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/
# Create wp-config from wp-config-sample and update the database settings
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/${var.db_name}/g" /var/www/html/wp-config.php
sed -i "s/username_here/${var.db_user}/g" /var/www/html/wp-config.php
sed -i "s/password_here/${var.db_password}/g" /var/www/html/wp-config.php
systemctl restart apache2
