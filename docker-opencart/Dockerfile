FROM php:8.2-apache
RUN apt-get update && apt-get install -y \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libxslt1-dev \
    libzip-dev \
    libonig-dev \
    libcurl4-gnutls-dev \
    libicu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd intl mbstring mysqli soap xml xsl zip pdo fileinfo pdo_mysql \
    && a2enmod rewrite headers \
    && service apache2 restart \
    && curl -L https://github.com/opencart/opencart/releases/download/3.0.4.0/opencart-3.0.4.0.zip -o ./opencart.zip \
    && apt-get install postfix -y
COPY ./opencart.zip /var/www/html/
RUN apt-get install -y unzip \
    && unzip /var/www/html/opencart.zip -d /var/www/html/ \
    && mv /var/www/html/upload/* /var/www/html/ \
    && cp /var/www/html/config-dist.php /var/www/html/config.php \
    && cp /var/www/html/admin/config-dist.php /var/www/html/admin/config.php \
    && chown -R www-data:www-data /var/www/
ENV PORT 8080
ENTRYPOINT []
CMD sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf \
    && docker-php-entrypoint apache2-foreground
