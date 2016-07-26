FROM centos:centos6
MAINTAINER http://www.vidalinux.com
LABEL Vendor="Vidalinux"
LABEL License=GPLv2
LABEL Version=1.0

RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm 
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN yum -y update && yum clean all
RUN yum -y install httpd mod_ssl && yum clean all
RUN yum --enablerepo=remi-php56 -y install memcached php56-php php56-php-mysqlnd php-cli php-gd php-mbstring \
php-mcrypt php-mysqlnd php-pdo php-pear php-pecl-apc php-pecl-memcache php-pecl-memcached \
php-pecl-mongo php-pgsql php-sqlite php-xml php-xml wget 
RUN wget http://vidalinux.com/files/starassistapp.tar.bz2 --http-user=user --http-password=password -O /tmp/starassistapp.tar.bz2 && tar xvfj /tmp/starassistapp.tar.bz2 -C /var/www/ && rm -rf /var/www/html && mv /var/www/starassist /var/www/html && rm -rf /tmp/starassistapp.tar.bz2

EXPOSE 80 443

# Simple startup script to avoid some issues observed with container restart 
ADD run-httpd.sh /run-httpd.sh 
RUN chmod -v +x /run-httpd.sh 
# change httpd.conf adding mod rewrite
ADD virtualhosts.conf /virtualhosts.conf
RUN cp /virtualhosts.conf /etc/httpd/conf.d/

CMD ["/run-httpd.sh"]
