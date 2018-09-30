#!/bin/sh
# value
SHARECONFIG=/share/smb.conf

set -x

# set config supervisord
if [ ! -f "/share/supervisord.conf" ]; then
cat <<EOF>> /share/supervisord.conf
[supervisord]
nodaemon=true
loglevel=info
# set some defaults and start samba in foreground (-F), logging to stdout (-S), and using our config (-s path)
[program:samba]
command=samba -i -s $SHARECONFIG
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
EOF
fi

# Fix nameserver
echo -e "search ${SAMBA_REALM}\nnameserver 127.0.0.1" > /etc/resolv.conf


# set config samba
if [ ! -f "$SHARECONFIG" ]; then

WORKGROUP=${WORKGROUP:-WORKGROUP}
HOSTNAME=$(hostname -s)

#ad setup
# Require $SAMBA_REALM to be set
: "${SAMBA_REALM:?SAMBA_REALM needs to be set}"

# Populate $SAMBA_OPTIONS
SAMBA_OPTIONS=${SAMBA_OPTIONS:-}

[ -n "$SAMBA_DOMAIN" ] \
    && SAMBA_OPTIONS="$SAMBA_OPTIONS --domain=$SAMBA_DOMAIN" \
    || SAMBA_OPTIONS="$SAMBA_OPTIONS --domain=${SAMBA_REALM%%.*}"

[ -n "$SAMBA_HOST_IP" ] && SAMBA_OPTIONS="$SAMBA_OPTIONS --host-ip=$SAMBA_HOST_IP"

# If $SAMBA_PASSWORD is not set, generate a password
SAMBA_PASSWORD=${SAMBA_PASSWORD:-`(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c20; echo) 2>/dev/null`}
echo "[INFO]Samba password set to: $SAMBA_PASSWORD"

cat <<EOF>> $SHARECONFIG
[global]
    server role = active directory domain controller
    realm = $SAMBA_REALM
    passdb backend = samba4
    idmap_ldb:use rfc2307 = yes
    idmap config ${SAMBA_DOMAIN}:unix_nss_info = yes
    idmap config ${SAMBA_DOMAIN}:unix_primary_group = yes
    
    netbios name = $HOSTNAME
    workgroup = ${SAMBA_REALM%%.*}
    #template shell = /bin/bash
    # setup ads
    dns forwarder = $SAMBA_DNS_FORWARDER
    #winbind use default domain = true
    #winbind offline logon = false
    #winbind nss info = rfc2307
    winbind enum users = yes
    winbind enum groups = yes
    #rpc server dynamic port range = 59140-59240
    #rpc server port:netlogon = 49143
    #rpc server port:drsuapi  = 49543
    #rpc server port:dcesrv   = 49443

    server string = Samba %v in an Alpine Linux Docker container
    #security = user
    #guest account = nobody
    #map to guest = Bad User
    log file = /dev/stdout
    #AFTERPROV log level = 1
    # disable printing services
    load printers = no
    printing = bsd
    printcap name = /dev/null
    disable spoolss = yes
    # getting rid of those annoying .DS_Store files created by Mac users...
    veto files = /._*/.DS_Store/
    delete veto files = yes
    # support extra stream
    vfs objects = streams_xattr
    #AFTERPROV vfs objects = acl_xattr streams_xattr full_audit
    #AFTERPROV full_audit:prefix = %u|%I|%m|%S
    #AFTERPROV full_audit:success = connect disconnect mkdir rmdir open close rename unlink
    #AFTERPROV full_audit:failure = connect opendir mkdir rmdir open unlink rename
    #AFTERPROV full_audit:facility = LOCAL7
    #AFTERPROV full_audit:priority = NOTICE
    map acl inherit = yes
    acl map full control = yes
    #inherit acls = yes
    #inherit owner = yes
    #inherit permissions = yes
    store dos attributes = yes
    force unknown acl user = false
[netlogon]
    path = /var/lib/samba/sysvol/$SAMBA_REALM/scripts
    read only = No
[sysvol]
    path = /var/lib/samba/sysvol
    read only = No
[data]
    path = /share/data
    read only = No
    hide unreadable = yes

EOF

mkdir /share/data
chgrp 3000000 /share/data
chmod 0770 /share/data

# Provision domain
rm -rf /etc/krb5.conf
rm -rf /etc/samba/smb.conf
rm -rf /var/lib/samba/private/*
rm -rf /var/lib/samba/sysvol/*
rm -f  /usr/samba/private/tls/*.pem
samba-tool domain provision \
    --configfile=$SHARECONFIG \
    --use-rfc2307 \
    --realm=${SAMBA_REALM} \
    --adminpass=${SAMBA_PASSWORD} \
    --server-role=dc \
    --dns-backend=SAMBA_INTERNAL \
    --debuglevel=3 \
    $SAMBA_OPTIONS \
    --option="bind interfaces only"=yes

echo -----------------------------
sed -e 's/#AFTERPROV |\s*vfs objects = streams_xattr//g' $SHARECONFIG
cat $SHARECONFIG
echo -----------------------------
if [ ! -e /var/lib/samba/private/krb5.conf ] ; then
  echo Provisioning is FAILED
  rm $SHARECONFIG
  exit -1
fi


# show status
samba-tool domain level show
fi

cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

exec "$@"
