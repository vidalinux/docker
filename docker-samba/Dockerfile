FROM almalinux:9.3
MAINTAINER http://www.vidalinux.com
LABEL Vendor="Vidalinux"
LABEL License=GPLv2
LABEL Version=1.0

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm && \
yum -y update && yum clean all && yum -y install samba samba-common samba-client -y && \
rm -fr /var/cache/*

# Move the Samba Conf file 

RUN mkdir /share

ADD runconfig.sh /
RUN chmod +x /runconfig.sh 

EXPOSE 445 445/udp 137-139/udp

CMD ["/runconfig.sh"]
