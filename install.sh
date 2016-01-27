#!/bin/bash

#lnamp一键安装
####全局变量 begin ####
export nginx_version=1.4.4
export httpd_version=2.2.29
export mysql_version=5.1.73
export php_version=5.3.29

export phpwind_version=8.7
export phpmyadmin_version=4.1.8
export vsftpd_version=2.3.2
export install_ftp_version=0.0.0
####全局变量 end ####


web=nginx
install_log=/lnamp/website-info.log


####版本选择 begin####
tmp=1
read -p "Select nginx/apache, input 1 or 2 : " tmp
if [ "$tmp" == "1" ];then
  web=nginx
elif [ "$tmp" == "2" ];then
  web=apache
fi

tmp=1
if echo $web | grep "nginx" > /dev/null;then
  read -p "Select the nginx version of 1.4.4, input 1: " tmp
  if [ "$tmp" == "1" ];then
    nginx_version=1.4.4
  fi
else
  read -p "Select the apache version of 2.2.29/2.4.10, input 1 or 2 : " tmp
  if [ "$tmp" == "1" ];then
    httpd_version=2.2.29
  elif [ "$tmp" == "2" ];then
    httpd_version=2.4.10
  fi
fi

if echo $web | grep "nginx" > /dev/null;then
  tmp=1
  read -p "Select the php version of 5.2.17/5.3.29/5.4.23/5.5.7, input 1 or 2 or 3 or 4 : " tmp
  if [ "$tmp" == "1" ];then
    php_version=5.2.17
  elif [ "$tmp" == "2" ];then
    php_version=5.3.29
  elif [ "$tmp" == "3" ];then
    php_version=5.4.23
  elif [ "$tmp" == "4" ];then
    php_version=5.5.7
  fi
else
  if echo $httpd_version | grep "2.2.29" > /dev/null;then
    tmp=1
    read -p "Select the php version of 5.2.17/5.3.29/5.4.23/5.5.7, input 1 or 2 or 3 or 4 : " tmp
    if [ "$tmp" == "1" ];then
      php_version=5.2.17
    elif [ "$tmp" == "2" ];then
      php_version=5.3.29
    elif [ "$tmp" == "3" ];then
      php_version=5.4.23
    elif [ "$tmp" == "4" ];then
      php_version=5.5.7
    fi
  else
    tmp=1
    read -p "Select the php version of 5.3.29/5.4.23/5.5.7, input 1 or 2 or 3 : " tmp
    if [ "$tmp" == "1" ];then
      php_version=5.3.29
    elif [ "$tmp" == "2" ];then
      php_version=5.4.23
    elif [ "$tmp" == "3" ];then
      php_version=5.5.7
    fi
  fi 
fi

tmp=1
read -p "Select the mysql version of 5.1.73/5.5.40/5.6.21, input 1 or 2 or 3 : " tmp
if [ "$tmp" == "1" ];then
  mysql_version=5.1.73
elif [ "$tmp" == "2" ];then
  mysql_version=5.5.40
elif [ "$tmp" == "3" ];then
  mysql_version=5.6.21
fi

echo "-----------------------"
echo "You select the version :"
echo "web: $web"
if echo $web | grep "nginx" > /dev/null;then
  echo "nginx: $nginx_version"
else
  echo "apache: $httpd_version"
fi
echo "php: $php_version"
echo "mysql: $mysql_version"

read -p "Enter the y or Y to continue : " isY
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ];then
  exit 1
fi
####版本选择 end####


####清除之前的安装 begin####
echo "will be installed, wait ..."
./uninstall.sh in &> /dev/null
####清除之前的安装 end####


if echo $web | grep "nginx" > /dev/null;then
  web_dir=nginx-${nginx_version}
else
  web_dir=httpd-${httpd_version}
fi

php_dir=php-${php_version}

if [ `uname -m` == "x86_64" ];then
  machine=x86_64
else
  machine=i686
fi


####补充全局变量 begin####
export web
export web_dir
export php_dir
export mysql_dir=mysql-${mysql_version}
export vsftpd_dir=vsftpd-${vsftpd_version}
####补充全局变量 end####


ifredhat=$(cat /proc/version | grep redhat)
ifcentos=$(cat /proc/version | grep centos)
ifubuntu=$(cat /proc/version | grep ubuntu)
ifdebian=$(cat /proc/version | grep -i debian)

####安装依赖 begin####
if [ "$ifredhat" != "" ];then
  rpm -e --allmatches mysql MySQL-python perl-DBD-MySQL dovecot exim qt-MySQL perl-DBD-MySQL dovecot qt-MySQL mysql-server mysql-connector-odbc php-mysql mysql-bench libdbi-dbd-mysql mysql-devel-5.0.77-3.el5 httpd php mod_auth_mysql mailman squirrelmail php-pdo php-common php-mbstring php-cli &> /dev/null
fi

if [ "$ifredhat" != "" ];then
  \mv /etc/yum.repos.d/rhel-debuginfo.repo /etc/yum.repos.d/rhel-debuginfo.repo.bak &> /dev/null
  \cp ./res/rhel-debuginfo.repo /etc/yum.repos.d/
  yum makecache
  yum -y remove mysql MySQL-python perl-DBD-MySQL dovecot exim qt-MySQL perl-DBD-MySQL dovecot qt-MySQL mysql-server mysql-connector-odbc php-mysql mysql-bench libdbi-dbd-mysql mysql-devel-5.0.77-3.el5 httpd php mod_auth_mysql mailman squirrelmail php-pdo php-common php-mbstring php-cli &> /dev/null
  yum -y install gcc gcc-c++ gcc-g77 make libtool autoconf patch unzip automake fiex* libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libmcrypt libmcrypt-devel libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl autoconf automake libaio*
elif [ "$ifcentos" != "" ];then
#	if grep 5.10 /etc/issue;then
	  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5 &> /dev/null
#	fi
  sed -i 's/^exclude/#exclude/' /etc/yum.conf
  yum makecache
  yum -y remove mysql MySQL-python perl-DBD-MySQL dovecot exim qt-MySQL perl-DBD-MySQL dovecot qt-MySQL mysql-server mysql-connector-odbc php-mysql mysql-bench libdbi-dbd-mysql mysql-devel-5.0.77-3.el5 httpd php mod_auth_mysql mailman squirrelmail php-pdo php-common php-mbstring php-cli &> /dev/null
  yum -y install gcc gcc-c++  make libtool autoconf patch unzip automake libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libmcrypt libmcrypt-devel libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl autoconf automake libaio*
  yum -y update bash
elif [ "$ifubuntu" != "" ];then
  apt-get -y update
  \mv /etc/apache2 /etc/apache2.bak &> /dev/null
  \mv /etc/nginx /etc/nginx.bak &> /dev/null
  \mv /etc/php5 /etc/php5.bak &> /dev/null
  \mv /etc/mysql /etc/mysql.bak &> /dev/null
  apt-get -y autoremove apache2 nginx php5 mysql-server &> /dev/null
  apt-get -y install unzip build-essential libncurses5-dev libfreetype6-dev libxml2-dev libssl-dev libcurl4-openssl-dev libjpeg62-dev libpng12-dev libfreetype6-dev libsasl2-dev libpcre3-dev autoconf libperl-dev libtool libaio*
  apt-get -y install --only-upgrade bash
elif [ "$ifdebian" != "" ];then
  apt-get -y update
  \mv /etc/apache2 /etc/apache2.bak &> /dev/null
  \mv /etc/nginx /etc/nginx.bak &> /dev/null
  \mv /etc/php5 /etc/php5.bak &> /dev/null
  \mv /etc/mysql /etc/mysql.bak &> /dev/null
  apt-get -y autoremove apache2 nginx php5 mysql-server &> /dev/null
  apt-get -y install unzip psmisc build-essential libncurses5-dev libfreetype6-dev libxml2-dev libssl-dev libcurl4-openssl-dev libjpeg62-dev libpng12-dev libfreetype6-dev libsasl2-dev libpcre3-dev autoconf libperl-dev libtool libaio*
  apt-get -y install --only-upgrade bash
fi
####安装依赖 end####


####安装软件 begin####
rm -rf tmp.log

./env/install_set_sysctl.sh
./env/install_set_ulimit.sh


./env/install_dir.sh
echo "---------- make dir ok ----------" >> tmp.log

./env/install_env.sh
echo "---------- env ok ----------" >> tmp.log

./mysql/install_${mysql_dir}.sh
echo "---------- ${mysql_dir} ok ----------" >> tmp.log

if echo $web | grep "nginx" > /dev/null;then
	./nginx/install_nginx-${nginx_version}.sh
	echo "---------- ${web_dir} ok ----------" >> tmp.log
	./php/install_nginx_php-${php_version}.sh
	echo "---------- ${php_dir} ok ----------" >> tmp.log
else
	./apache/install_httpd-${httpd_version}.sh
	echo "---------- ${web_dir} ok ----------" >> tmp.log
	./php/install_httpd_php-${php_version}.sh
	echo "---------- ${php_dir} ok ----------" >> tmp.log
fi

./php/install_php_extension.sh
echo "---------- php extension ok ----------" >> tmp.log

./ftp/install_${vsftpd_dir}.sh
install_ftp_version=$(vsftpd -v 0 > vsftpd_version && cat vsftpd_version | awk -F: '{print $2}'|awk '{print $2}' && rm -f vsftpd_version)
echo "---------- vsftpd-$install_ftp_version  ok ----------" >> tmp.log

./res/install_soft.sh
echo "---------- default ok ----------" >> tmp.log
echo "---------- phpmyadmin-$phpmyadmin_version ok ----------" >> tmp.log
echo "---------- web init ok ----------" >> tmp.log
####安装软件 end####

cat /etc/redhat-release | grep 7\..* | grep -i centos > /dev/null
if [ ! $? -ne  0 ] ;then
  systemctl stop firewalld.service 
  systemctl disable firewalld.service
  cp /etc/rc.local /etc/rc.local.bak > /dev/null
  cp /etc/rc.d/rc.local /etc/rc.d/rc.local.bak > /dev/null
  chmod u+x /etc/rc.local
  chmod u+x /etc/rc.d/rc.local
else 
  cp /etc/rc.local /etc/rc.local.bak > /dev/null
  cp /etc/rc.d/rc.local /etc/rc.d/rc.local.bak > /dev/null
  echo "it is not centos7"
fi


####设置开机启动 begin####
if ! cat /etc/rc.local | grep "/etc/init.d/mysqld" > /dev/null;then 
  echo "/etc/init.d/mysqld start" >> /etc/rc.local
fi
if echo $web | grep "nginx" > /dev/null;then
  if ! cat /etc/rc.local | grep "/etc/init.d/nginx" > /dev/null;then 
    echo "/etc/init.d/nginx start" >> /etc/rc.local
	  echo "/etc/init.d/php-fpm start" >> /etc/rc.local
  fi
else
  if ! cat /etc/rc.local | grep "/etc/init.d/httpd" > /dev/null;then 
    echo "/etc/init.d/httpd start" >> /etc/rc.local
  fi
fi
cat /etc/redhat-release | grep 7\..* | grep -i centos > /dev/null
if [ ! $? -ne  0 ] ;then
  echo "systemctl start vsftpd.service" >> /etc/rc.local
else 
  if ! cat /etc/rc.local | grep "/etc/init.d/vsftpd" > /dev/null;then 
    echo "/etc/init.d/vsftpd start" >> /etc/rc.local
  fi
  echo "it is not centos7"
fi
echo "---------- rc init ok ----------" >> tmp.log
####设置开机启动 end####


####centos yum configuration begin####
if [ "$ifcentos" != "" ] && [ "$machine" == "x86_64" ];then
  sed -i 's/^#exclude/exclude/' /etc/yum.conf
fi
if [ "$ifubuntu" != "" ] || [ "$ifdebian" != "" ];then
	mkdir -p /var/lock
	sed -i 's#exit 0#touch /var/lock/local#' /etc/rc.local
else
	mkdir -p /var/lock/subsys/
fi
####centos yum configuration end####

####mysql 密码初始化 begin####
/lnamp/server/php/bin/php -f ./res/init_mysql.php
echo "---------- mysql init ok ----------" >> tmp.log
####mysql 密码初始化 end####


####环境变量配置 begin####
\cp /etc/profile /etc/profile.bak
if echo $web | grep "nginx" > /dev/null;then
  echo 'export PATH=$PATH:/lnamp/server/mysql/bin:/lnamp/server/nginx/sbin:/lnamp/server/php/sbin:/lnamp/server/php/bin' >> /etc/profile
  export PATH=$PATH:/lnamp/server/mysql/bin:/lnamp/server/nginx/sbin:/lnamp/server/php/sbin:/lnamp/server/php/bin
else
  echo 'export PATH=$PATH:/lnamp/server/mysql/bin:/lnamp/server/httpd/bin:/lnamp/server/php/sbin:/lnamp/server/php/bin' >> /etc/profile
  export PATH=$PATH:/lnamp/server/mysql/bin:/lnamp/server/httpd/bin:/lnamp/server/php/sbin:/lnamp/server/php/bin
fi
####环境变量配置 end####


####重启 begin####
if echo $web | grep "nginx" > /dev/null;then
  /etc/init.d/php-fpm restart > /dev/null
  /etc/init.d/nginx restart > /dev/null
else
  /etc/init.d/httpd restart > /dev/null
  /etc/init.d/httpd start &> /dev/null
fi

cat /etc/redhat-release | grep 7\..* | grep -i centos>/dev/null
if [ ! $? -ne  0 ] ;then
  systemctl start vsftpd.service
else 
  /etc/init.d/vsftpd restart
fi

####重启 end####

####日志 begin####
\cp tmp.log $install_log
\cp ./account.log /lnamp/
cat $install_log
####日志 end####