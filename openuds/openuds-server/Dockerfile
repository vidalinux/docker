FROM alt:latest
MAINTAINER Vidalinux
# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG en_US.UTF-8

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN apt-get update && \
apt-get install -y openuds-server openuds-server-nginx nano su 

# Expose services
EXPOSE 443 80

# Copy the default config file
COPY openuds-server.sh /usr/share/openuds/openuds-server.sh
COPY openuds-taskmanager.sh /usr/share/openuds/openuds-taskmanager.sh

RUN mkdir /run/openuds && \
chmod +x /usr/share/openuds/openuds-taskmanager.sh \
         /usr/share/openuds/openuds-server.sh && \
chown openuds.openuds /etc/openuds/settings.py \
      /usr/share/openuds/openuds-taskmanager.sh \
      /usr/share/openuds/openuds-server.sh \
      /run/openuds

# Set default user when running the container
#USER openuds

# Copy entrypoint.sh
COPY entrypoint.sh /entrypoint.sh 
RUN chmod +x /entrypoint.sh && apt-get install -y python3-module-pyvmomi

#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["/entrypoint.sh"]
