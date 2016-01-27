#!/bin/bash
rm -rf php-5.5.7
if [ ! -f php-5.5.7.tar.gz ];then
  wget http://res1.coder4j.com/onekey/php/php-5.5.7.tar.gz
fi
tar -zxvf php-5.5.7.tar.gz
cd php-5.5.7
./configure --prefix=/lnamp/server/php \
--enable-opcache \
--with-config-file-path=/lnamp/server/php/etc \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--enable-fpm \
--enable-fastcgi \
--enable-static \
--enable-inline-optimization \
--enable-sockets \
--enable-wddx \
--enable-zip \
--enable-calendar \
--enable-bcmath \
--enable-soap \
--with-zlib \
--with-iconv \
--with-gd \
--with-xmlrpc \
--enable-mbstring \
--without-sqlite \
--with-curl \
--enable-ftp \
--with-mcrypt  \
--with-freetype-dir=/usr/local/freetype.2.1.10 \
--with-jpeg-dir=/usr/local/jpeg.6 \
--with-png-dir=/usr/local/libpng.1.2.50 \
--disable-ipv6 \
--disable-debug \
--with-openssl \
--disable-maintainer-zts \
--disable-safe-mode \
--disable-fileinfo

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
  make ZEND_EXTRA_LIBS='-liconv' -j$CPU_NUM
else
  make ZEND_EXTRA_LIBS='-liconv'
fi
make install
cd ..
cp ./php-5.5.7/php.ini-production /lnamp/server/php/etc/php.ini
#adjust php.ini
sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "/lnamp/server/php/lib/php/extensions/no-debug-non-zts-20121212/"#'  /lnamp/server/php/etc/php.ini
sed -i 's#extension_dir = \"\.\/\"#extension_dir = "/lnamp/server/php/lib/php/extensions/no-debug-non-zts-20121212/"#'  /lnamp/server/php/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /lnamp/server/php/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /lnamp/server/php/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' /lnamp/server/php/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' /lnamp/server/php/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /lnamp/server/php/etc/php.ini
#adjust php-fpm
cp /lnamp/server/php/etc/php-fpm.conf.default /lnamp/server/php/etc/php-fpm.conf
sed -i 's,user = nobody,user=www,g'   /lnamp/server/php/etc/php-fpm.conf
sed -i 's,group = nobody,group=www,g'   /lnamp/server/php/etc/php-fpm.conf
sed -i 's,^pm.min_spare_servers = 1,pm.min_spare_servers = 5,g'   /lnamp/server/php/etc/php-fpm.conf
sed -i 's,^pm.max_spare_servers = 3,pm.max_spare_servers = 35,g'   /lnamp/server/php/etc/php-fpm.conf
sed -i 's,^pm.max_children = 5,pm.max_children = 100,g'   /lnamp/server/php/etc/php-fpm.conf
sed -i 's,^pm.start_servers = 2,pm.start_servers = 20,g'   /lnamp/server/php/etc/php-fpm.conf
sed -i 's,;pid = run/php-fpm.pid,pid = run/php-fpm.pid,g'   /lnamp/server/php/etc/php-fpm.conf
sed -i 's,;error_log = log/php-fpm.log,error_log = /lnamp/log/php/php-fpm.log,g'   /lnamp/server/php/etc/php-fpm.conf
sed -i 's,;slowlog = log/$pool.log.slow,slowlog = /lnamp/log/php/\$pool.log.slow,g'   /lnamp/server/php/etc/php-fpm.conf
#self start
install -v -m755 ./php-5.5.7/sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm
/etc/init.d/php-fpm start
sleep 5