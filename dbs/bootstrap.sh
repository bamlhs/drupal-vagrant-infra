#!/usr/bin/env bash
apt update
apt-get install -y software-properties-common
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
add-apt-repository 'deb [arch=amd64] http://mirror.zol.co.zw/mariadb/repo/10.3/ubuntu bionic main'
apt update
apt -y install mariadb-server mariadb-client

service mysql restart

echo "Installation Done, Feel Free to sleep now"