#!/bin/bash

#default
cat > /lnamp/www/default/index.php << END
<?php
echo phpinfo();
END
chmod -R 777 /lnamp/www/default/index.php

#phpmyadmin
if [ "$php_version" == "5.2.17" ];then
  if [ ! -f phpmyadmin.zip ];then
    wget http://res1.coder4j.com/onekey/mysql/phpMyAdmin-4.0.10.10-all-languages.zip
  fi
  rm -rf phpMyAdmin-4.0.10.10-all-languages
  unzip phpMyAdmin-4.0.10.10-all-languages.zip
  mv phpMyAdmin-4.0.10.10-all-languages /lnamp/www/default/phpmyadmin
else 
  if [ ! -f phpmyadmin.zip ];then
    wget http://res1.coder4j.com/onekey/mysql/phpMyAdmin-4.1.8-all-languages.zip
  fi
  rm -rf phpMyAdmin-4.1.8-all-languages
  unzip phpMyAdmin-4.1.8-all-languages.zip
  mv phpMyAdmin-4.1.8-all-languages /lnamp/www/default/phpmyadmin
fi

chown -R www:www /lnamp/www/default/