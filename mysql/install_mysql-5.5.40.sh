#!/bin/bash

ifubuntu=$(cat /proc/version | grep ubuntu)
if14=$(cat /etc/issue | grep 14)

if [ `uname -m` == "x86_64" ];then
  machine=x86_64
else
  machine=i686
fi
if [ $machine == "x86_64" ];then
  rm -rf mysql-5.5.40-linux2.6-x86_64
  if [ ! -f mysql-5.5.40-linux2.6-x86_64.tar.gz ];then
	  wget http://res1.coder4j.com/onekey/mysql/mysql-5.5.40-linux2.6-x86_64.tar.gz
  fi
  tar -xzvf mysql-5.5.40-linux2.6-x86_64.tar.gz
  mv mysql-5.5.40-linux2.6-x86_64/* /lnamp/server/mysql
else
  rm -rf mysql-5.5.40-linux2.6-i686
  if [ ! -f mysql-5.5.40-linux2.6-i686.tar.gz ];then
    wget http://res1.coder4j.com/onekey/mysql/mysql-5.5.40-linux2.6-i686.tar.gz
  fi
  tar -xzvf mysql-5.5.40-linux2.6-i686.tar.gz
  mv mysql-5.5.40-linux2.6-i686/* /lnamp/server/mysql
fi

if [ "$ifubuntu" != "" ] && [ "$if14" != "" ];then
	mv /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
fi

groupadd mysql
useradd -g mysql -s /sbin/nologin mysql
/lnamp/server/mysql/scripts/mysql_install_db --datadir=/lnamp/server/mysql/data/ --basedir=/lnamp/server/mysql --user=mysql
chown -R mysql:mysql /lnamp/server/mysql/
chown -R mysql:mysql /lnamp/server/mysql/data/
chown -R mysql:mysql /lnamp/log/mysql
\cp -f /lnamp/server/mysql/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir=/lnamp/server/mysql#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir=/lnamp/server/mysql/data#' /etc/init.d/mysqld
\cp -f /lnamp/server/mysql/support-files/my-medium.cnf /etc/my.cnf
echo "expire_logs_days = 5" >> /etc/my.cnf
echo "max_binlog_size = 1000M" >> /etc/my.cnf
sed -i 's#skip-external-locking#skip-external-locking\nlog-error=/lnamp/log/mysql/error.log#' /etc/my.cnf

chmod 755 /etc/init.d/mysqld
/etc/init.d/mysqld start