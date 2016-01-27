#!/bin/bash

ifubuntu=$(cat /proc/version | grep ubuntu)

userdel www
groupadd www
if [ "$ifubuntu" != "" ];then
  useradd -g www -M -d /lnamp/www -s /usr/sbin/nologin www &> /dev/null
else
  useradd -g www -M -d /lnamp/www -s /sbin/nologin www &> /dev/null
fi

mkdir -p /lnamp
mkdir -p /lnamp/server
mkdir -p /lnamp/www
mkdir -p /lnamp/www/default
mkdir -p /lnamp/log
mkdir -p /lnamp/log/php
mkdir -p /lnamp/log/mysql
chown -R www:www /lnamp/log

mkdir -p /lnamp/server/${mysql_dir}
ln -s /lnamp/server/${mysql_dir} /lnamp/server/mysql

mkdir -p /lnamp/server/${php_dir}
ln -s /lnamp/server/${php_dir} /lnamp/server/php


mkdir -p /lnamp/server/${web_dir}
if echo $web | grep "nginx" > /dev/null;then
  mkdir -p /lnamp/log/nginx
  mkdir -p /lnamp/log/nginx/access
  ln -s /lnamp/server/${web_dir} /lnamp/server/nginx
else
  mkdir -p /lnamp/log/httpd
  mkdir -p /lnamp/log/httpd/access
  ln -s /lnamp/server/${web_dir} /lnamp/server/httpd
fi
