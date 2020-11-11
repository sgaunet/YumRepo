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

> /etc/nginx/.htpasswd

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

exec $@