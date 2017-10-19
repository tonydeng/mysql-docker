#!/bin/sh
# docker entrypoint script
# configures and start MySQL

echo "[i] Start MySQL with config /etc/mysql/my.cnf"

if [ ! -f /mysql/conf/mysql/my.cnf ]; then
    echo "[i] MySQL config file not found, copy from /etc/mysql"
    mkdir -p /mysql/conf/mysql
    cp /etc/mysql/my.cnf /mysql/conf/mysql/
fi

if [ -d /mysql/data/mysql ]; then
    echo "[i] MySQL directory already present, skipping creation"
else
    echo "[i] MySQL data directory not found, creating initial DBs"

    mkdir -p /mysql/data/mysql

    mysql_install_db --user=root >> /dev/null

    if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
        MYSQL_ROOT_PASSWORD=`pwgen 16 1`
        echo "[i] MySQL root password: $MYSQL_ROOT_PASSWORD"
        echo $MYSQL_ROOT_PASSWORD > /mysql/conf/mysql/root_password
        echo $MYSQL_ROOT_PASSWORD > /mysql/data/mysql/root_password
    fi

    MYSQL_DATABASE=${MYSQL_DATABASE:-""}
    MYSQL_USER=${MYSQL_USER:-""}
    MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

    tfile=`mktemp`

    if [ ! -f "$tfile" ]; then
        return 1
    fi

    cat << EOF >> $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost'  WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("") WHERE user='root' and host='localhost';
EOF

    if [ "$MYSQL_DATABASE" != ""]; then
        echo "[i] Creating database: $MYSQL_DATABASE"
        echo "CREATE DATABSE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

        if [ "$MYSQL_USER" != "" ]; then
            echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
            echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
        fi
    fi

    /usr/bin/mysqld --init-file=$tfile --user=root --verbose=0
    rm -f $tfile
fi

# start MySQL, move to CMD in Dockerfile
# /usr/bin/mysqld --user=root --console --character-set-server=utf8

# run command passed to docker run
exec "$@"
