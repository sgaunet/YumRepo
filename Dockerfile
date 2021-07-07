FROM nginx:1.21.1

RUN apt-get update && apt-get install -y \
  createrepo \
  apache2-utils \
  inotify-tools \
  && rm -rf /var/lib/apt/lists/*


COPY conf/nginx.conf         /etc/nginx/nginx.conf
COPY conf/supervisord.conf  /etc/supervisord.conf

COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord

COPY src/create-repo.sh  /usr/local/bin/create-repo.sh
COPY src/entrypoint.sh  /usr/local/entrypoint.sh
RUN chmod 755 /usr/local/entrypoint.sh /usr/local/bin/create-repo.sh

EXPOSE 9001
EXPOSE 80
ENTRYPOINT [ "/usr/local/entrypoint.sh" ]
CMD ["/usr/local/bin/supervisord","-c","/etc/supervisor.conf"]
