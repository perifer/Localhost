#!/usr/bin/env bash

if [ -z "$MYSQL_PASS" ]; then
    read -s -p "Enter a password used for MySQL root user: " MYSQL_PASS
fi

#brew install homebrew/apache/httpd24 mysql dnsmasq
brew install mysql

brew services start mysql
brew services restart mysql

mysql -u root -e "UPDATE mysql.user SET Password = PASSWORD('$MYSQL_PASS') WHERE User = 'root'"
mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -u root -e "DROP DATABASE test"
mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
mysql -u root -e "FLUSH PRIVILEGES"

#brew install homebrew/php/php56 --with-httpd24
#brew unlink homebrew/php/php56
#brew install homebrew/php/php70 --with-httpd24
#brew unlink homebrew/php/php70
#brew install homebrew/php/php71 --with-httpd24
