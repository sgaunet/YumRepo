# YumRepo

YumRepo launch a Nginx Webserver with a basic Authentication to expose private yum repository.
The repodata of yum repositories is kept updated as soon as there is a new file in the directory.

The createrepo command is launched only for directories named RPMS (to be mounted /usr/share/nginx/html)

# Run

conf.env :

```
USER_UI=toto
PASSWORD_UI=tata
LST_USERS_PASSWORDS=user1:user1 user2:user2
```

* USER_UI : user to access to supervisord
* PASSWORD_UI: password to access to supervisord
* LST_USERS_PASSWORDS: List of couple login:password that can access to Nginx

Set LST_USERS_PASSWORDS as empty to avoid the authentication.

docker-compose.yml:

```
version: '3.2'

services:
  WWW:
    image: sgaunet/yumrepo:latest
    restart: always
    env_file:
      - conf.env
    ports:
      - "8000:80"     # Nginx
      - "9001:9001"   # supervisord IHM
    volumes:
      - ./example:/usr/share/nginx/html
```

Expose 9001 to access to the [supervisord IHM](https://github.com/ochinchina/supervisord).

# Build

```
./build.sh
```

# .htpasswd

[See here](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/)
