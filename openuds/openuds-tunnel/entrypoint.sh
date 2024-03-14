#!/bin/bash

# set uds server hostname
sed -i "s|serveruds.ovox.io|${SERVER_HOST}|g" /etc/guacamole/guacamole.properties
sed -i "s|serveruds.ovox.io|${SERVER_HOST}|g" /etc/openuds-tunnel/udstunnel.conf

# configure tomcat ssl certificates
sed -i 's|certificateFile=*.*|certificateFile="'"${SSL_CRT}"'"|g' /etc/tomcat/server.xml
sed -i 's|certificateKeyFile=*.*|certificateKeyFile="'"${SSL_KEY}"'"|g' /etc/tomcat/server.xml
sed -i 's|certificateChainFile=*.*|certificateChainFile="'"${SSL_CA}"'" />|g' /etc/tomcat/server.xml

# configure udstunnel.conf ssl certificates
sed -i "s|ssl_certificate =*.*|ssl_certificate = ${SSL_CRT}|g" /etc/openuds-tunnel/udstunnel.conf
sed -i "s|ssl_certificate_key =*.*|ssl_certificate_key = ${SSL_KEY}|g" /etc/openuds-tunnel/udstunnel.conf

# configure udstunnel token
sed -i "s|guacamole/auth/*.*|guacamole/auth/${TUNNEL_TOKEN}|g" /etc/guacamole/guacamole.properties
sed -i "s|uds_token =*.*|uds_token = ${TUNNEL_TOKEN}|g" /etc/openuds-tunnel/udstunnel.conf

# create dh key
if [ ! -f /etc/openuds-tunnel/ssl/openuds-tunnel.dh ];
then
openssl dhparam -out /etc/openuds-tunnel/ssl/openuds-tunnel.dh 1024
fi

# trust ca cert
cp ${SSL_CA} /etc/pki/ca-trust/source/anchors/
update-ca-trust

/usr/bin/python3 /usr/share/openuds/tunnel/udstunnel.py -t &
/usr/libexec/tomcat/server start &
/usr/local/bin/add-tunel-to-db.sh
/usr/sbin/guacd -b 0.0.0.0 -f $OPTS
