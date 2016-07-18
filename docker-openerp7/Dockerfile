FROM ubuntu:trusty
# Use PostgreSQL user "openerp"

# Install "openerp.deb"
RUN echo deb http://nightly.odoo.com/7.0/nightly/deb/ ./ \
    > /etc/apt/sources.list.d/openerp-70.list 
ENV DEBIAN_FRONTEND noninteractive 
ENV LANG en_US.UTF-8 
RUN apt-get update 
RUN apt-get install -y --allow-unauthenticated openerp 
RUN apt-get install -y git 

ENV ADDON /usr/lib/python2.7/dist-packages/openerp/addons
WORKDIR /tmp
RUN git clone https://github.com/shine-it/oecn_base_fonts.git
RUN cp -a oecn_base_fonts/oecn_base_fonts $ADDON
RUN apt-get install -y fonts-wqy-zenhei
# Expose HTTP port
EXPOSE 8069

COPY openerp-server.conf /openerp-server.conf
COPY entrypoint.sh /entrypoint.sh
RUN chown openerp /openerp-server.conf /entrypoint.sh
USER openerp
ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server", "-c", "/openerp-server.conf"]

