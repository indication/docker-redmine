FROM alpine:latest

LABEL Description="Simple and lightweight Samba docker container, based on Alpine Linux." Version="0.1"

# install samba and supervisord and clear the cache afterwards
RUN apk add --no-cache samba-dc krb5 supervisor

# create a dir for the config and the share
RUN mkdir /share

# copy start script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# volume mappings
#VOLUME ["/config", "/share"]
VOLUME ["/share","/var/lib/samba"]

# exposes samba's default ports (137, 138 for nmbd and 139, 445 for smbd)
# DNS*                    53    tcp/udp
# Kerberos                88    tcp/udp
# End Point Mapper       135    tcp
# NetBIOS Name Service   137    udp
# NetBIOS Datagram       138    udp
# NetBIOS Session        139    tcp
# LDAP                   389    tcp/udp
# SMB over TCP           445    tcp
# Kerberos kpasswd       464    tcp/udp
# LDAPS **               636    tcp
# Global Catalog        3268    tcp
# Global Catalog SSL ** 3269    tcp 
# Dynamic RPC Ports ***  49152-65535     tcp
#         netlogon to 49143
#         drsuapi  to 49543
EXPOSE 53 53/udp 88 88/udp 135 137-138/udp 139 389 389/udp 445 464 464/udp 636 1024 3268 3269 49143 49443 49543

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord", "-c", "/share/supervisord.conf"]
