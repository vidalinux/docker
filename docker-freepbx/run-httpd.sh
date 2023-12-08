#!/bin/bash

WORKDIR=/usr/local/src/freepbx

if [ ! -f /var/www/html/.pbx ];
then
# start asterisk
cd ${WORKDIR}
./start_asterisk start
# install freepbx
sleep 5
./install --dbengine=${DBENGINE} --dbname=${DBNAME} --dbhost=${DBHOST} --dbport=${DBPORT} \
--cdrdbname=${CDRDBNAME} --dbuser=${DBUSER} --dbpass=${DBPASS} --user=${USER}  --group=${GROUP} \
--webroot=${WEBROOT} --astetcdir=${ASTETCDIR} --astmoddir=${ASTMODDIR} --astvarlibdir=${ASTVARLIBDIR} \
--astagidir=${ASTAGIDIR} --astspooldir=${ASTSPOOLDIR} --astrundir=${ASTRUNDIR} --astlogdir=${ASTLOGDIR} \
--ampbin=${AMPBIN} --ampsbin=${AMPSBIN} --ampcgibin=${AMPCGIBIN}  --ampplayback=${AMPPLAYBACK} -n
# configure freepbx
fwconsole ma installall
fwconsole reload
fwconsole restart
touch /var/www/html/.pbx
mkdir /var/lib/asterisk/etc
cp /etc/freepbx.conf /var/lib/asterisk/etc/
chown -R asterisk:asterisk /var/lib/asterisk/etc
# start httpd service
/usr/sbin/apachectl -DFOREGROUND
else
# start asterisk
cd ${WORKDIR}
./start_asterisk start
# fix simlinks
ln -s /var/lib/asterisk/etc/freepbx.conf /etc/freepbx.conf
ln -s /var/lib/asterisk/bin/fwconsole /usr/sbin/fwconsole
# configure freepbx
fwconsole reload
fwconsole restart
# start httpd service
/usr/sbin/apachectl -DFOREGROUND
fi
