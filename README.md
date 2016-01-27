# Linux Nginx/Apache MySql PHP

## 概览

`lnamp` 是一个 Linux Nginx/Apache MySql PHP 一键安装脚本。  

目前包含的环境信息如下：

- nginx: 1.4.4
- apache: 2.2.29、2.4.10
- mysql: 5.1.73、5.5.40、5.6.21
- php: 5.2.17、5.3.29、5.4.23、5.5.7
- php 扩展: memcache、Zend
- ftp: (yum/apt-get 安装) 
- phpmyadmin: 4.1.8

适用CentOS, Debian, Ubuntu and RHEL.

为什么不都选用最新版本呢？因为我就是想搭建个普通的能凑合稳定使用的环境，够用就行了，如果有必要，后期可能会加入较新的版本。  

之所有有此项目，是因为我想搭建一个个人博客，购置了服务器，但缺少环境，对于一个专注开发的苦逼程序猿，搭建一个服务器环境确实不是易事。

此安装脚本是我搜罗来的，靠着自己贫瘠的Shell知识，对脚本的每行每句进行查看修改。虽说一些配置，参数啥的我不太懂，但由于个人水平有限，保持原样。项目放在这里一是希望帮助到和我有相同需求的小伙伴，二是希望有大牛帮助修改共同进步（应该没人需要，哈哈）。

Github 上资源确实太丰富了，没事应该多搜搜，比如你可以搜 `lnmp` , `lamp` 你就可以搜到很多大牛写的功能强悍的集成安装脚本了（有空我也去借点砖）。

也不能太贬低这个小项目了，至少我用着挺顺手的，只能说还有提升的空间。用不用随你，至少得告诉你怎么用吧。

## 安装

请确保服务器可以连接网络（此话多余）。

确保 `yum` 或 `apt-get` 正确配置，推荐使用 [网易开源镜像](http://mirrors.163.com/.help/)。

确保服务器能使用 `wget` 下载命令，没有此命令的请自行安装，很多系统自带的有。

确保使用root账户登录（不多解释）。

使用此脚本非常简单：

1，下载本脚本包，右上角的 `Download ZIP`.

2，上传到你的服务器的某一个目录下，例如：`/root/`.

3，对文件进行解压缩。

```
# 根据你下载的包名进行解压 lnamp-*.zip
unzip lnamp-master.zip
```

4，为避免脚本无法执行，为目录设置权限。

```
# 此步不一定必须但建议执行一下
chmod -R 755 lnamp-master
```

5，进入到解压目录。

```
cd lnamp-master
```

6，执行安装脚本。

```
./install.sh
```

会提示你选择哪种环境及版本，如下所示：

```
Select nginx/apache, input 1 or 2 : 1
Select the nginx version of 1.4.4, input 1: 1
Select the php version of 5.2.17/5.3.29/5.4.23/5.5.7, input 1 or 2 or 3 or 4 : 4
Select the mysql version of 5.1.73/5.5.40/5.6.21, input 1 or 2 or 3 : 3
-----------------------
You select the version :
web: nginx
nginx: 1.4.4
php: 5.5.7
mysql: 5.6.21
Enter the y or Y to continue :y
```

`lnamp` 的所有软件（除`yum`,`apt-get`安装的）都在 `/lnamp` 目录中，不用担心会把你原本的环境搞乱的。

确认版本信息后，输入 `y` 回车，静静的等待它自动下载安装吧（根据网络和机器配置不同大概需要10-30分钟）。

安装完成后，会输出类似下面的内容：

```
---------- make dir ok ----------
---------- env ok ----------
---------- mysql-5.6.21 ok ----------
---------- nginx-1.4.4 ok ----------
---------- php-5.5.7 ok ----------
---------- php extension ok ----------
---------- vsftpd-  ok ----------
---------- default ok ----------
---------- phpmyadmin-4.1.8 ok ----------
---------- web init ok ----------
---------- rc init ok ----------
---------- mysql init ok ----------
```

分别执行下面的命令（根据你选的环境），查看相应的软件是否启动成功：

```
# 查看nginx环境
ps -ef | grep nginx
ps -ef | grep php-fpm
ps -ef | grep mysql
ps -ef | grep ftp
# 查看apache环境
ps -ef | grep httpd
ps -ef | grep mysql
ps -ef | grep ftp
# 或者查看端口启用情况（mysql 3306,php-fpm 9000,nginx/httpd 80,ftp 21）
netstat -tunpl
```

相关的软件已经默认配置到服务中，并设置了开机自启。

ftp账号和mysql账号信息在：`/lnamp/account.log` 中。

```
more /lnamp/account.log
# 看到类似下面的内容
##########################################################################
#
# thank you for using lnamp
#
##########################################################################

FTP:
account:www
password:你的ftp密码

MySQL:
account:root
password:你的mysql密码
```

## 使用

如果上面的安装成功，其实就可以正常使用了，访问 `http://你的服务器IP` ，即可以看到当前环境的 `phpinfo()` 信息。

安装完成的目录结构如下：

```
/lnamp
|--account.log    #上面提到的账号信息
|--/log           #存放日志的目录
   |--/mysql       #mysql日志
      |--error.log
   |--/nginx       #nginx日志
      |--/access    #access日志
      |--error.log
   |--/httpd       #httpd日志
   	  |--/access
   	  |--error.log
   |--/php
      |--php-fpm.log
|--/server        #安装的软件目录
   |--/php
   |--/mysql
   |--/httpd
   |--/nginx
|--website-info.log     #安装过程部分日志记录
|--/www         #web目录
   |--/default   #默认的访问目录，里面有个index.php
   |--/phpmyadmin  #phpMyAdmin,web mysql客户端
```

下面介绍一下各个软件的启动，停止，重启等操作。

启动，停止等操作都已经放置到：`/etc/init.d/` 中，你可以通过如下方式进行操作：

```
# nginx
/etc/init.d/nginx start/stop/restart/reload
# apache
/etc/init.d/httpd start/stop/restart
# mysql
/etc/init.d/mysqld start/stop/restart
# php-fpm
/etc/init.d/php-fpm start/stop/restart
# ftp
/etc/init.d/vsftpd start/stop/restart
```

或者使用service方式

```
# nginx
service nginx start/stop/restart/reload
# apache
service httpd start/stop/restart
# mysql
service mysqld start/stop/restart
# php-fpm
service php-fpm start/stop/restart
# ftp
service vsftpd start/stop/restart
```

## 卸载

卸载非常简单，只需要执行：

```
./uninstall.sh
```

## 其他

此脚本中使用的软件包默认从我的个人资源点：[res1.coder4j.com](http://res1.coder4j.com/onekey/) 进行下载。

如有任何问题和意见，欢迎提交 [issues](https://github.com/Chinaxiang/lnamp/issues/new). 或者访问我的 [个人网站](http://www.huangyanxiang.com/home/index/messages) 进行留言。

