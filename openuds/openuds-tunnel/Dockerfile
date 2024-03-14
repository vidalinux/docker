FROM alt:latest
MAINTAINER Vidalinux
# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG en_US.UTF-8

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN apt-get update && \
apt-get install -y openuds-tunnel su mariadb-client 

# Expose services
EXPOSE 8080 7777 10443 4822

# Copy configuration files
COPY server.xml /etc/tomcat/server.xml
COPY guacamole.properties /etc/guacamole/guacamole.properties
COPY udstunnel.conf /etc/openuds-tunnel/udstunnel.conf
COPY add-tunel-to-db.sh /usr/local/bin/add-tunel-to-db.sh
COPY entrypoint.sh /entrypoint.sh

# Set permissions
RUN chmod +x /entrypoint.sh /usr/local/bin/add-tunel-to-db.sh

#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["/entrypoint.sh"]
