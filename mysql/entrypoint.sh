#!/bin/bash

if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    echo "MYSQL_ROOT_PASSWORD environment variable not found"
    exit 1
fi

echo "MYSQL_ROOT_PASSWORD received"

exec /entrypoint.sh mysqld


###!/bin/bash
##
##if [ -f /tmp/mysql-root-password.txt ]; then
##    PASSWORD=$(cat /tmp/mysql-root-password.txt)
##    echo "Accessed Root password"
##else
##    echo "Password file not found"
##    exit 1
##fi
### Making it as available in env
##export MYSQL_ROOT_PASSWORD=$PASSWORD
##rm -rf /tmp/mysql_root_password.txt
##exec /entrypoint.sh mysqld
#
##!/bin/bash
#
#if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
#    echo "MYSQL_ROOT_PASSWORD environment variable not found"
#    exit 1
#fi
#
#echo "MYSQL_ROOT_PASSWORD received"
#
#exec /entrypoint.sh mysqld