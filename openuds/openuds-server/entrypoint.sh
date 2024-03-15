#!/bin/bash

WORKDIR=/usr/share/openuds
cd ${WORKDIR}

if [ ! -d /run/openuds ];
then
mkdir /run/openuds
chown openuds.openuds /run/openuds
fi

# set database on settings.py
sed -i "s|'NAME': '*.*'|'NAME': '${MYSQL_DATABASE}'|g" /etc/openuds/settings.py
sed -i "s|'USER': '*.*'|'USER': '${MYSQL_USER}'|g" /etc/openuds/settings.py
sed -i "s|'PASSWORD': '*.*'|'PASSWORD': '${MYSQL_PASSWORD}'|g" /etc/openuds/settings.py
sed -i "s|'HOST': '*.*'|'HOST': '${MYSQL_HOST}'|g" /etc/openuds/settings.py
sed -i "s|TIME_ZONE = \ *.*|TIME_ZONE = '${TIME_ZONE}'|g" /etc/openuds/settings.py
sed -i "s|LANGUAGE_CODE = \ *.*|LANGUAGE_CODE = '${LANGUAGE_CODE}'|g" /etc/openuds/settings.py

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
