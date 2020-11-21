#!/usr/bin/env bash

echo "Update supervisord configuration"
if [ ! -z ${USER_UI} ]
then
    sed -i "s#;username=test1#username=${USER_UI}#g" /etc/supervisord.conf
fi

if [ ! -z ${PASSWORD_UI} ]
then
    sed -i "s#;password=thepassword#password=${PASSWORD_UI}#g"  /etc/supervisord.conf
fi

if [ -z "${REPODATA_FOLDER}" ]
then
    echo "REPODATA_FOLDER must be specified"
    exit 1
fi

> /etc/nginx/.htpasswd

if [ ! -z "$LST_USERS_PASSWORDS" ]
then
    echo "Generation of .htpassword"
    for i in ${LST_USERS_PASSWORDS}
    do
        user=$(echo $i | cut -d: -f1)
        password=$(echo $i | cut -d: -f2)
        #echo "$user:$password" >> /etc/nginx/.htpasswd
        htpasswd -b -c /etc/nginx/.htpasswd.$$  $user $password
        cat /etc/nginx/.htpasswd.$$ >> /etc/nginx/.htpasswd
        rm /etc/nginx/.htpasswd.$$
    done
else
    sed -i '/auth_basic/d' /etc/nginx/nginx.conf
fi

exec $@