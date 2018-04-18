# Apache, MySQL and PHP on macOS

Local PHP development with minimal work to add new sites. Create a directory, e.g. `site.test/public_html` and add your files – that's all. No config files to edit, no server to restart.

Other features:

* All config files easily editable in `~/Localhost/config` and version controlled
* Easy switching between different versions of PHP
* Trivial to share with colleagues or move to a different Mac.

## Add a new site using a symlink

Many projects have their web root in a subfolder or call it something else then `public_html`. Therefore the recommended approach is to use a symlink for `public_html`.

```
mkdir -p ~/Sites/site.test/
cd ~/Sites/site.test
ln -s site/path/to/web_root public_html
```

## Switch PHP version

```
switchphp 56
switchphp 70
switchphp 71
switchphp 72
```

## Requirements

* Tested on macOS High Sierra
* [Homebrew](https://brew.sh)

## Installation

Install all dependencies:

```
brew install httpd mysql dnsmasq

brew install homebrew/php/php56 --with-httpd
brew unlink homebrew/php/php56
brew install homebrew/php/php70 --with-httpd
brew unlink homebrew/php/php70
brew install homebrew/php/php71 --with-httpd
brew unlink homebrew/php/php71
brew install homebrew/php/php72 --with-httpd
```

Clone the repo in your home directory. Copy `~/Localhost/config/mysql/my.cnf.example`, name it `my.cnf` and add a password. Like this:

```
git clone https://github.com/perifer/Localhost.git ~/Localhost
cp ~/Localhost/config/mysql/my.cnf.example ~/Localhost/config/mysql/my.cnf
nano ~/Localhost/config/mysql/my.cnf
```

Enable the config files and switchphp utility:

```
echo "Include \${HOME}/Localhost/config/apache/httpd.conf" >> /usr/local/etc/httpd/httpd.conf
ln -s ~/Localhost/config/apache/php-modules-available/php71.conf ~/Localhost/config/apache/php.conf

ln -s ~/Localhost/config/mysql/my.cnf /usr/local/etc/

mkdir -p /usr/local/etc/php/5.6/conf.d/ /usr/local/etc/php/7.0/conf.d/ /usr/local/etc/php/7.1/conf.d/
ln -s ~/Localhost/config/php/php.ini /usr/local/etc/php/5.6/conf.d/
ln -s ~/Localhost/config/php/php.ini /usr/local/etc/php/7.0/conf.d/
ln -s ~/Localhost/config/php/php.ini /usr/local/etc/php/7.1/conf.d/
ln -s ~/Localhost/config/php/php.ini /usr/local/etc/php/7.2/conf.d/

ln -s ~/Localhost/config/dnsmasq/dnsmasq.conf /usr/local/etc/dnsmasq.conf
sudo mkdir -p /etc/resolver
sudo ln -s ~/Localhost/config/dnsmasq/test /etc/resolver/test

ln -s ~/Localhost/bin/switchphp /usr/local/bin/
```

Remove or comment out all lines starting with `LoadModule php5_module` or `LoadModule php7_module` in `/usr/local/etc/apache2/2.4/httpd.conf`.

Start all services:

```
sudo brew services start httpd
brew services start mysql
sudo brew services start dnsmasq
```

Secure MySQL. Set the password to the same one you added in `~/Localhost/config/mysql/my.cnf`:

`mysql_secure_installation`

Setup Apache log file (this is ONLY needed if you run Apache a separate user, which is the default):

```
touch ~/Localhost/logs/php-apache.log
sudo chown _www:_www ~/Localhost/logs/php-apache.log
```

## Recommended PHP extensions

* phpXX-opcache
* phpXX-mcrypt
* phpXX-xdebug
