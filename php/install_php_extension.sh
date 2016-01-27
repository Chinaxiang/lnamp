#!/bin/bash
ifsuse=$(cat /proc/version | grep -i suse)

if [ `uname -m` == "x86_64" ];then
  machine=x86_64
else
  machine=i686
fi

#memcache
if [ ! -f memcache-3.0.6.tgz ];then
	wget http://res1.coder4j.com/onekey/php_extend/memcache-3.0.6.tgz
fi
rm -rf memcache-3.0.6
tar -xzvf memcache-3.0.6.tgz
cd memcache-3.0.6
/lnamp/server/php/bin/phpize
./configure --enable-memcache --with-php-config=/lnamp/server/php/bin/php-config
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
  make -j$CPU_NUM
else
  make
fi
make install
cd ..

echo "extension=memcache.so" >> /lnamp/server/php/etc/php.ini

#zend
if ls -l /lnamp/server/ | grep "5.3.29" > /dev/null;then
  mkdir -p /lnamp/server/php/lib/php/extensions/no-debug-non-zts-20090626/
  if [ $machine == "x86_64" ];then
	  if [ ! -f ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz ];then
		  wget http://res1.coder4j.com/onekey/php_extend/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz
	  fi
	  tar -zxvf ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz
	  mv ./ZendGuardLoader-php-5.3-linux-glibc23-x86_64/php-5.3.x/ZendGuardLoader.so /lnamp/server/php/lib/php/extensions/no-debug-non-zts-20090626/
  else
    if [ ! -f ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz ];then
      wget http://res1.coder4j.com/onekey/php_extend/ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz
	  fi
	  tar -zxvf ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz
	  mv ./ZendGuardLoader-php-5.3-linux-glibc23-i386/php-5.3.x/ZendGuardLoader.so /lnamp/server/php/lib/php/extensions/no-debug-non-zts-20090626/
  fi
  echo "zend_extension=/lnamp/server/php/lib/php/extensions/no-debug-non-zts-20090626/ZendGuardLoader.so" >> /lnamp/server/php/etc/php.ini
  echo "zend_loader.enable=1" >> /lnamp/server/php/etc/php.ini
  echo "zend_loader.disable_licensing=0" >> /lnamp/server/php/etc/php.ini
  echo "zend_loader.obfuscation_level_support=3" >> /lnamp/server/php/etc/php.ini
  echo "zend_loader.license_path=" >> /lnamp/server/php/etc/php.ini 
elif ls -l /lnamp/server/ | grep "5.2.17" > /dev/null;then
  mkdir -p /lnamp/server/php/lib/php/extensions/no-debug-non-zts-20060613/
  if [ $machine == "x86_64" ];then
	  if [ ! -f ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz ];then 
		  wget http://res1.coder4j.com/onekey/php_extend/ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz
	  fi
	  tar -zxvf ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz
    mv ./ZendOptimizer-3.3.9-linux-glibc23-x86_64/data/5_2_x_comp/ZendOptimizer.so  /lnamp/server/php/lib/php/extensions/no-debug-non-zts-20060613/
  else
    if [ ! -f ZendOptimizer-3.3.9-linux-glibc23-i386.tar.gz ];then 
		  wget http://res1.coder4j.com/onekey/php_extend/ZendOptimizer-3.3.9-linux-glibc23-i386.tar.gz
	  fi
	  tar -zxvf ZendOptimizer-3.3.9-linux-glibc23-i386.tar.gz
	  mv ./ZendOptimizer-3.3.9-linux-glibc23-i386/data/5_2_x_comp/ZendOptimizer.so /lnamp/server/php/lib/php/extensions/no-debug-non-zts-20060613/
  fi
  echo "[zend]" >> /lnamp/server/php/etc/php.ini
  echo "zend_optimizer.optimization_level=1023" >> /lnamp/server/php/etc/php.ini
  echo "zend_optimizer.encoder_loader=1"        >> /lnamp/server/php/etc/php.ini
  echo "zend_extension=/lnamp/server/php/lib/php/extensions/no-debug-non-zts-20090626/ZendOptimizer.so" >> /lnamp/server/php/etc/php.ini
elif ls -l /lnamp/server/ | grep "5.4.23" > /dev/null;then
  mkdir -p /lnamp/server/php/lib/php/extensions/no-debug-non-zts-20100525/
  if [ $machine == "x86_64" ];then
	  if [ ! -f ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz ];then 
		  wget http://res1.coder4j.com/onekey/php_extend/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
	  fi
	  tar -zxvf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
	  mv ./ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64/php-5.4.x/ZendGuardLoader.so /lnamp/server/php/lib/php/extensions/no-debug-non-zts-20100525/
  else
    if [ ! -f ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz ];then 
		  wget http://res1.coder4j.com/onekey/php_extend/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz
	  fi
	  tar -zxvf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz
	  mv ./ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386/php-5.4.x/ZendGuardLoader.so /lnamp/server/php/lib/php/extensions/no-debug-non-zts-20100525/
  fi
  echo "zend_extension=/lnamp/server/php/lib/php/extensions/no-debug-non-zts-20100525/ZendGuardLoader.so" >> /lnamp/server/php/etc/php.ini
  echo "zend_loader.enable=1" >> /lnamp/server/php/etc/php.ini
  echo "zend_loader.disable_licensing=0" >> /lnamp/server/php/etc/php.ini
  echo "zend_loader.obfuscation_level_support=3" >> /lnamp/server/php/etc/php.ini
  echo "zend_loader.license_path=" >> /lnamp/server/php/etc/php.ini 
elif ls -l /lnamp/server/ | grep "5.5.7" > /dev/null;then
  mkdir -p /lnamp/server/php/lib/php/extensions/no-debug-non-zts-20121212/
  if [ $machine == "x86_64" ];then
    wget http://res1.coder4j.com/onekey/php_extend/zend-loader-php5.5-linux-x86_64.tar.gz
    tar -zxvf zend-loader-php5.5-linux-x86_64.tar.gz
    mv ./zend-loader-php5.5-linux-x86_64/ZendGuardLoader.so /lnamp/server/php/lib/php/extensions/no-debug-non-zts-20121212/
  else
    wget http://res1.coder4j.com/onekey/php_extend/zend-loader-php5.5-linux-i386.tar.gz
    tar -zxvf zend-loader-php5.5-linux-i386.tar.gz
    mv ./zend-loader-php5.5-linux-i386/ZendGuardLoader.so /lnamp/server/php/lib/php/extensions/no-debug-non-zts-20121212/
  fi
  echo "zend_extension=/lnamp/server/php/lib/php/extensions/no-debug-non-zts-20121212/ZendGuardLoader.so" >> /lnamp/server/php/etc/php.ini
  echo "zend_loader.enable=1" >> /lnamp/server/php/etc/php.ini
  echo "zend_loader.disable_licensing=0" >> /lnamp/server/php/etc/php.ini
  echo "zend_loader.obfuscation_level_support=3" >> /lnamp/server/php/etc/php.ini
  echo "zend_loader.license_path=" >> /lnamp/server/php/etc/php.ini
fi

