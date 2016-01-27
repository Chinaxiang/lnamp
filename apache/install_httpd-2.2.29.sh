#!/bin/bash
rm -rf httpd-2.2.29
if [ ! -f httpd-2.2.29.tar.gz ];then
  wget http://res1.coder4j.com/onekey/httpd/httpd-2.2.29.tar.gz
fi
tar -zxvf httpd-2.2.29.tar.gz
cd httpd-2.2.29
./configure --prefix=/lnamp/server/httpd \
--with-mpm=prefork \
--enable-so \
--enable-rewrite \
--enable-mods-shared=all \
--enable-nonportable-atomics=yes \
--disable-dav \
--enable-deflate \
--enable-cache \
--enable-disk-cache \
--enable-mem-cache \
--enable-file-cache
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
  make -j$CPU_NUM
else
  make
fi
make install
cp support/apachectl /etc/init.d/httpd
chmod u+x /etc/init.d/httpd
cd ..

cp /lnamp/server/httpd/conf/httpd.conf /lnamp/server/httpd/conf/httpd.conf.bak

sed -i "s#LoadModule rewrite_module modules/mod_rewrite.so#LoadModule rewrite_module modules/mod_rewrite.so\nLoadModule php5_module modules/libphp5.so#" /lnamp/server/httpd/conf/httpd.conf
sed -i "s#User daemon#User www#" /lnamp/server/httpd/conf/httpd.conf
sed -i "s#Group daemon#Group www#" /lnamp/server/httpd/conf/httpd.conf
sed -i "s;#ServerName www.example.com:80;ServerName www.example.com:80;" /lnamp/server/httpd/conf/httpd.conf
sed -i "s#/lnamp/server/httpd/htdocs#/lnamp/www#" /lnamp/server/httpd/conf/httpd.conf
sed -i "s#<Directory />#<Directory \"/lnamp/www\">#" /lnamp/server/httpd/conf/httpd.conf
sed -i "s#AllowOverride None#AllowOverride all#" /lnamp/server/httpd/conf/httpd.conf
sed -i "s#DirectoryIndex index.html#DirectoryIndex index.html index.htm index.php#" /lnamp/server/httpd/conf/httpd.conf
sed -i "s;#Include conf/extra/httpd-mpm.conf;Include conf/extra/httpd-mpm.conf;" /lnamp/server/httpd/conf/httpd.conf
sed -i "s;#Include conf/extra/httpd-vhosts.conf;Include conf/extra/httpd-vhosts.conf;" /lnamp/server/httpd/conf/httpd.conf

echo "HostnameLookups off" >> /lnamp/server/httpd/conf/httpd.conf
echo "AddType application/x-httpd-php .php" >> /lnamp/server/httpd/conf/httpd.conf

echo "NameVirtualHost *:80" > /lnamp/server/httpd/conf/extra/httpd-vhosts.conf
echo "Include /lnamp/server/httpd/conf/vhosts/*.conf" >> /lnamp/server/httpd/conf/extra/httpd-vhosts.conf


mkdir -p /lnamp/server/httpd/conf/vhosts/
cat > /lnamp/server/httpd/conf/vhosts/default.conf << END

<VirtualHost *:80>
	DocumentRoot /lnamp/www/default
	ServerName localhost
	ServerAlias localhost
	<Directory "/lnamp/www/default">
	    Options Indexes FollowSymLinks
	    AllowOverride all
	    Order allow,deny
	    Allow from all
	</Directory>
	<IfModule mod_rewrite.c>
		RewriteEngine On
		RewriteCond %{REQUEST_FILENAME} !-d
		RewriteCond %{REQUEST_FILENAME} !-f
		RewriteRule ^(.*)$ index.php/$1 [QSA,PT,L]
	</IfModule>
	ErrorLog "/lnamp/log/httpd/default-error.log"
	CustomLog "/lnamp/log/httpd/access/default.log" common
</VirtualHost>
END

#adjust httpd-mpm.conf
sed -i 's/StartServers          5/StartServers         10/g' /lnamp/server/httpd/conf/extra/httpd-mpm.conf
sed -i 's/MinSpareServers       5/MinSpareServers      10/g' /lnamp/server/httpd/conf/extra/httpd-mpm.conf
sed -i 's/MaxSpareServers      10/MaxSpareServers      30/g' /lnamp/server/httpd/conf/extra/httpd-mpm.conf
sed -i 's/MaxClients          150/MaxClients          255/g' /lnamp/server/httpd/conf/extra/httpd-mpm.conf

/etc/init.d/httpd start
