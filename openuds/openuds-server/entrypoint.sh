#!/bin/bash

WORKDIR=/usr/share/openuds
cd ${WORKDIR}

if [ ! -d /run/openuds ];
then
mkdir /run/openuds
chown openuds.openuds /run/openuds
fi

# set database on settings.py
sed -i "s|'NAME': 'udsdb'|'NAME': '${MYSQL_DATABASE}'|g" /etc/openuds/settings.py
sed -i "s|'USER': 'uds'|'USER': '${MYSQL_USER}'|g" /etc/openuds/settings.py
sed -i "s|'PASSWORD': 'uds'|'PASSWORD': '${MYSQL_PASSWORD}'|g" /etc/openuds/settings.py

# initialize database
su -s /bin/bash - openuds -c "cd /usr/share/openuds; /usr/bin/python3 manage.py migrate"

# start openuds-web service
su -s /bin/bash - openuds -c "cd /usr/share/openuds; /usr/bin/gunicorn.py3 --pid /run/openuds/pid \
          --bind unix:/run/openuds/socket server.wsgi \
          --workers 5 --threads 8" &

# configure and start nginx service
ln -s /etc/nginx/sites-available.d/openuds.conf /etc/nginx/sites-enabled.d/openuds.conf
sed -i "s|ssl_certificate \ *.*|ssl_certificate ${SSL_CRT};|g" /etc/nginx/sites-enabled.d/openuds.conf
sed -i "s|ssl_certificate_key \ *.*|ssl_certificate_key ${SSL_KEY};|g" /etc/nginx/sites-enabled.d/openuds.conf
/usr/sbin/nginx -g 'daemon off;' &

# start openuds-task-manager
su -s /bin/bash - openuds -c "cd /usr/share/openuds; /usr/bin/python3 /usr/share/openuds/manage.py taskManager --start --foreground"
