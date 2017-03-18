#!/bin/bash

if ! [ "$(id -u)" = "0" ]; then
    echo "run as root!"
    exit
fi

# dependencies
(
cat <<EOF
apache2
automake
autoconf
libapache2-mod-perl2-dev
libperl-AppConfig
libappconfig-perl
libcrypt-cbc-perl
libcrypt-des-perl
libcgi-pm-perl
libdbi-perl
libdate-calc-perl
libio-stringy-perl
libipc-shareable-perl
libjson-perl
libspreadsheet-parseexcel-perl
libtext-csv-xs-perl
libtie-ixhash-perl
libxml-simple-perl
librole-tiny-perl
make
unzip
EOF
) >/tmp/pkgs

# install dependencies
for a in $(cat /tmp/pkgs); do sudo apt -y install $a; done

# build Bedrock from latest release
wget -q https://github.com/rlauer6/openbedrock/archive/master.zip
unzip master.zip
cd openbedrock-master/
./configure --prefix=/usr
make && make install

# setup Apache for Bedrock
a2dismod mpm_worker
a2dismod mpm_event
a2enmod mpm_prefork
a2enmod cgi
a2enmod actions

# install website
cp /usr/lib/bedrock/config/perl_bedrock.conf /etc/apache2/conf-available/
a2enconf perl_bedrock

# change permissions of log directory
mkdir -p /var/www/log/html
chown -R www-data:www-data /var/www/log

# setup website
for a in cgi-bin pebbles include session html html/bedrock log log/html; do
  [ ! -d /var/www/$a ] && mkdir /var/www/$a
done

for a in index.rock error.roc itworks.rock notworking.html; do
  cp /usr/share/bedrock/htdocs/$a /var/www/html
done

cp /usr/lib//bedrock/cgi-bin/bedrock.cgi /var/www/cgi-bin/bedrock.cgi

(
cat <<EOF
ScriptAlias /cgi-bin /var/www/cgi-bin

<Directory /var/www/cgi-bin>
  AllowOverride None
  Order allow,deny
  Allow from all
  Options ExecCGI SymLinksIfOwnerMatch
</Directory>
EOF
) > /etc/apache2/conf-available/bedrock-website-serve-cgi-bin.conf

a2enconf bedrock-website-serve-cgi-bin

# restart apache
service apache2 restart
