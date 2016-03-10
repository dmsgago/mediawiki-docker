#!/bin/bash
set -e

chown -R mysql:mysql /var/lib/mysql

/usr/bin/mysql &

dbfile="tempdbfile"

cat << EOF > $dbfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("$MYSQL_ROOT_PASSWORD") WHERE user='root';
EOF

echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $dbfile
echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $dbfile

/usr/sbin/mysqld --bootstrap --verbose=0 < $dbfile
rm -f $dbfile

/usr/sbin/apache2ctl -D FOREGROUND
