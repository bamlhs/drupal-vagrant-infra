#!/usr/bin/env bash

apt-get update

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

apt-get install -y apache2
apt-get install -y libapache2-mod-fastcgi
cd /tmp
wget http://mirrors.kernel.org/ubuntu/pool/multiverse/liba/libapache-mod-fastcgi/libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb
dpkg -i libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb
apt install -f

apt-get install -y software-properties-common
add-apt-repository -y ppa:ondrej/php
apt update
apt install -y php7.2 php7.2-fpm php7.2-common php7.2-gd  php7.2-xml php7.2-zip php7.2-mysql
a2enmod actions fastcgi alias proxy_fcgi
a2enmod rewrite

chown -R vagrant:vagrant /var/lib/apache2/fastcgi
chown vagrant:vagrant /var/run/php/php7.2-fpm.sock

if ! [ -L /etc/apache2/apache2.conf ]; then
  rm /etc/apache2/apache2.conf
  ln -s /vagrant/apache2/apache2.conf /etc/apache2/apache2.conf
fi


if ! [ -L /etc/php/7.2/fpm/php.ini ]; then
  rm /etc/php/7.2/fpm/php.ini
  ln -s /vagrant/php.ini /etc/php/7.2/fpm/php.ini
fi


if ! [ -L /etc/apache2/sites-enabled/000-default.conf ]; then
  rm /etc/apache2/sites-enabled/000-default.conf
  ln -s /vagrant/apache2/000-default.conf /etc/apache2/sites-enabled/000-default.conf
fi
if ! [ -L /etc/apache2/sites-available/000-default.conf ]; then
  rm /etc/apache2/sites-available/000-default.conf
  ln -s /vagrant/apache2/000-default.conf /etc/apache2/sites-available/000-default.conf
fi

if ! [ -L /etc/apache2/ports.conf ]; then
  rm /etc/apache2/ports.conf
  ln -s /vagrant/apache2/ports.conf /etc/apache2/ports.conf
fi

if ! [ -L /var/www ]; then
  rm -rf /var/ww
  mkdir -p /vagrant/docroot
  ln -fs /vagrant/docroot /var/www
fi

systemctl restart apache2.service
echo "Installation Done, Feel Free to sleep now"