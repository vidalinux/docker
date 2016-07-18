FROM ubuntu:trusty
# Use PostgreSQL user "openerp"

# Install "openerp.deb"
ENV DEBIAN_FRONTEND noninteractive 
ENV LANG en_US.UTF-8 
RUN apt-get update 
WORKDIR /tmp
RUN apt-get install -y python-dateutil python-feedparser python-gdata \
python-ldap python-libxslt1 python-lxml python-mako python-openid python-psycopg2 \
python-pybabel python-pychart python-pydot python-pyparsing python-reportlab \
python-simplejson python-tz python-vatnumber python-vobject python-webdav \
python-werkzeug python-xlwt python-yaml python-zsi python-pip wget
RUN pip install werkzeug==0.8.3
RUN adduser --system --home=/opt/openerp --group openerp
RUN wget https://nightly.odoo.com/old/openerp-6.1/6.1.0/openerp-6.1-1.tar.gz && tar xvf openerp-6.1-1.tar.gz -C /opt/openerp && cd /opt/openerp && cp -a openerp-6.1-1 server && chown -R openerp: *

# Expose HTTP port
EXPOSE 8069

COPY openerp-server.conf /openerp-server.conf
COPY entrypoint.sh /entrypoint.sh
RUN chown openerp /openerp-server.conf /entrypoint.sh
USER openerp
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/opt/openerp/server/openerp-server", "-c", "/openerp-server.conf"]
