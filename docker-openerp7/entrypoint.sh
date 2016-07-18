#!/bin/bash

set -e

# set odoo database host, port, user and password
CONF=/openerp-server.conf
echo "addons_path = $ADDON" >> $CONF
echo "db_host = $POSTGRES_HOST" >> $CONF 
echo "db_port = $POSTGRES_PORT" >> $CONF
echo "db_user = $POSTGRES_USER" >> $CONF
echo "db_password = $POSTGRES_PASSWORD" >> $CONF

#su openerp
exec "$@"



