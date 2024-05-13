FROM php:8.3.7-cli AS deployer
ENV OSTICKET_VERSION=1.18.1
RUN set -x \
    && apt-get update \
    && apt-get install -y git-core \
    && git clone -b v${OSTICKET_VERSION} --depth 1 https://github.com/osTicket/osTicket.git \
    && cd osTicket \
    && php manage.php deploy -sv /data/upload \
    # www-data is uid:gid 82:82 in php:8.2-fpm-alpine
    && chown -R 82:82 /data/upload \
    # Hide setup
    && mv /data/upload/setup /data/upload/setup_hidden \
    && chown -R root:root /data/upload/setup_hidden \
    && chmod -R go= /data/upload/setup_hidden

FROM php:8.3.7-fpm-alpine
MAINTAINER Antonio Velez <acvelez@vidalinux.com>
# environment for osticket
ENV HOME=/data
# setup workdir
WORKDIR /data
COPY --from=deployer /data/upload upload
RUN set -x && \
    # requirements and PHP extensions
    apk add --no-cache --update \
        wget \
        msmtp \
        ca-certificates \
        supervisor \
        nginx \
        libpng \
	oniguruma-dev \
        c-client \
        openldap \
        libintl \
        libxml2 \
        icu \
        openssl \
	zip \
	libzip-dev && \
    apk add --no-cache --virtual .build-deps \
        imap-dev \
        libpng-dev \
        curl-dev \
        linux-headers \
        openldap-dev \
        gettext-dev \
        libxml2-dev \
        icu-dev \
        autoconf \
        g++ \
        make \
        pcre-dev && \
    docker-php-ext-install gd curl ldap mysqli sockets gettext mbstring xml intl opcache && \
    docker-php-ext-configure imap --with-imap-ssl && \
    docker-php-ext-install imap && \
    docker-php-ext-configure zip && \
    docker-php-ext-install zip && \
    pecl install apcu && docker-php-ext-enable apcu && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    # Download languages packs
    wget -nv -O upload/include/i18n/fr.phar https://s3.amazonaws.com/downloads.osticket.com/lang/fr.phar && \
    wget -nv -O upload/include/i18n/ar.phar https://s3.amazonaws.com/downloads.osticket.com/lang/ar.phar && \
    wget -nv -O upload/include/i18n/pt_BR.phar https://s3.amazonaws.com/downloads.osticket.com/lang/pt_BR.phar && \
    wget -nv -O upload/include/i18n/it.phar https://s3.amazonaws.com/downloads.osticket.com/lang/it.phar && \
    wget -nv -O upload/include/i18n/es_ES.phar https://s3.amazonaws.com/downloads.osticket.com/lang/es_ES.phar && \
    wget -nv -O upload/include/i18n/de.phar https://s3.amazonaws.com/downloads.osticket.com/lang/de.phar && \
    mv upload/include/i18n upload/include/i18n.dist && \
    # Download LDAP plugin
    wget -nv -O upload/include/plugins/auth-ldap.phar https://s3.amazonaws.com/downloads.osticket.com/plugin/auth-ldap.phar && \
    # Create msmtp log
    touch /var/log/msmtp.log && \
    chown www-data:www-data /var/log/msmtp.log && \
    # File upload permissions
    mkdir -p /var/tmp/nginx && \
    chown nginx:www-data /var/tmp/nginx && chmod g+rx /var/tmp/nginx
COPY files/ /
VOLUME ["/data/upload/include/plugins","/data/upload/include/i18n","/var/log/nginx"]
EXPOSE 80
CMD ["/data/bin/start.sh"]
