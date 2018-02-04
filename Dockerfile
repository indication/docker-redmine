FROM alpine:latest

LABEL Description="Simple and lightweight Samba docker container, based on Alpine Linux." Version="0.1"

# install samba and supervisord and clear the cache afterwards
RUN apk add --no-cache samba samba-common-tools supervisor

# create a dir for the config and the share
RUN mkdir /config /share

# copy start script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# volume mappings
#VOLUME ["/config", "/share"]
VOLUME ["/share"]

# exposes samba's default ports (137, 138 for nmbd and 139, 445 for smbd)
EXPOSE 137/udp 138/udp 139 445

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord", "-c", "/config/supervisord.conf"]