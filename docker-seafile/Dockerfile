FROM phusion/baseimage:0.9.15

RUN apt-get update && apt-get install -y \
        ca-certificates \
        python2.7 \
        python-setuptools \
        python-simplejson \
        python-imaging \
        sqlite3 \
        python-mysqldb \
        wget \
        pwgen 

# disable ssh 
RUN apt-get remove openssh-server -y && apt-get autoremove -y
RUN rm /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN rm /etc/init/ssh.conf
RUN rm /etc/init.d/ssh
RUN rm /etc/network/if-up.d/openssh-server

ENV SEAFILE_VERSION 5.1.4

RUN useradd -d /opt/seafile -m seafile
WORKDIR /opt/seafile
RUN wget https://bintray.com/artifact/download/seafile-org/seafile/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz --no-check-certificate
RUN tar xzf seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz
RUN rm seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz
RUN mkdir -p logs

# config env variables

ENV autostart true
ENV autoconf true
ENV SERVER_IP 172.17.0.3
ENV FILESERVER_PORT 8082
#ENV SEAFILE_DIR none
ENV USE_EXISTING_DB 0
ENV MYSQL_USER seafileuser
ENV MYSQL_HOST 172.17.0.2
ENV MYSQL_PORT 3306
ENV MYSQL_ROOT_PASSWD vidalinux
ENV MYSQL_USER_HOST 172.17.0.3
ENV MYSQL_USER_PASSWD vidalinux
ENV CCNET_DB ccnetdb
ENV SEAFILE_DB seafiledb
ENV SEAHUB_DB seahubdb
ENV SEAHUB_ADMIN_EMAIL admin@ovoxcloud.com
ENV SEAHUB_ADMIN_PASSWORD vidalinux

# removing default seafile installation scripts to replace them with our own

RUN rm seafile-server-${SEAFILE_VERSION}/check_init_admin.py
RUN rm seafile-server-${SEAFILE_VERSION}/setup-seafile-mysql.py
COPY scripts/check_init_admin.py /opt/seafile/seafile-server-${SEAFILE_VERSION}/check_init_admin.py
COPY scripts/setup-seafile-mysql.py /opt/seafile/seafile-server-${SEAFILE_VERSION}/setup-seafile-mysql.py

# adding all our scripts
RUN mkdir -p /etc/my_init.d
COPY scripts/setup-seafile-mysql.sh /etc/my_init.d/setup-seafile-mysql.sh
COPY scripts/create_nginx_config.sh /etc/my_init.d/z_create_nginx_config.sh
COPY nginx.conf /root/seafile.conf
RUN chown -R seafile:seafile /opt/seafile

# seafile daemons
RUN mkdir /etc/service/seafile /etc/service/seahub -p
COPY scripts/seafile.sh /etc/service/seafile/run
COPY scripts/seahub.sh /etc/service/seahub/run

EXPOSE 8000 8082

# baseimage init process
ENTRYPOINT ["/sbin/my_init"]
