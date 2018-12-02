#!/usr/bin/env bash
apt update
apt install -y varnish


if ! [ -L /etc/varnish/default.vcl ]; then
  rm /etc/varnish/default.vcl
  ln -s /vagrant/default.vcl /etc/varnish/default.vcl
fi

service varnish restart

echo "Installation Done, Feel Free to sleep now"