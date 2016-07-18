FROM centos:latest
MAINTAINER http://www.centos.org
LABEL Vendor="CentOS"
LABEL License=GPLv2
LABEL Version=2.4.6-31

RUN rpm -Uvh http://mirror.cpsc.ucalgary.ca/mirror/fedora-epel/7/x86_64/e/epel-release-7-7.noarch.rpm 
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum -y update && yum clean all
RUN yum -y install httpd mod_ssl && yum clean all
RUN yum --enablerepo=remi-php56 -y install php56-php php56-php-mysqlnd memcached wget php-pecl-apc php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongo php-sqlite php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml patch
RUN wget http://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz && tar xvfz /tmp/wordpress.tar.gz -C /var/www/ && rm -rf /var/www/html && mv /var/www/wordpress /var/www/html && rm -rf /tmp/wordpress.tar.gz

EXPOSE 80 443

# Simple startup script to avoid some issues observed with container restart 
ADD run-httpd.sh /run-httpd.sh 
RUN chmod -v +x /run-httpd.sh 
# change httpd.conf adding mod rewrite
ADD virtualhosts.conf /virtualhosts.conf
RUN cp /virtualhosts.conf /etc/httpd/conf.d/

CMD ["/run-httpd.sh"]
