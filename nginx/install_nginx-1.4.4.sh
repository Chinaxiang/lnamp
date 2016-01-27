#!/bin/bash
rm -rf nginx-1.4.4
if [ ! -f nginx-1.4.4.tar.gz ];then
  wget http://res1.coder4j.com/onekey/nginx/nginx-1.4.4.tar.gz
fi

tar -zxvf nginx-1.4.4.tar.gz
cd nginx-1.4.4
./configure --user=www \
--group=www \
--prefix=/lnamp/server/nginx \
--with-http_stub_status_module \
--without-http-cache \
--with-http_ssl_module \
--with-http_gzip_static_module
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
  make -j$CPU_NUM
else
  make
fi
make install
chmod 775 /lnamp/server/nginx/logs
chown -R www:www /lnamp/server/nginx/logs
chmod -R 775 /lnamp/www
chown -R www:www /lnamp/www
cd ..
cp -fR ./nginx/config-nginx/* /lnamp/server/nginx/conf/
sed -i 's/worker_processes  2/worker_processes  '"$CPU_NUM"'/' /lnamp/server/nginx/conf/nginx.conf
chmod 755 /lnamp/server/nginx/sbin/nginx
#/lnamp/server/nginx/sbin/nginx
mv /lnamp/server/nginx/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx

/etc/init.d/nginx start