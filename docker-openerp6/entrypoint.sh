#!/bin/bash

set -e

# set odoo database host, port, user and password
CONF=/openerp-server.conf
echo "db_host = $POSTGRES_HOST" >> $CONF 
echo "db_port = $POSTGRES_PORT" >> $CONF
echo "db_user = $POSTGRES_USER" >> $CONF
echo "db_password = $POSTGRES_PASSWORD" >> $CONF
echo "db_name = $POSTGRES_DBNAME" >> $CONF
echo "dbfilter = $POSTGRES_DBNAME" >> $CONF

#su openerp
exec "$@"



