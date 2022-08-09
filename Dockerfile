FROM php:7.4-fpm-buster

# Add some packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install bash wget ca-certificates openssl git tar openssh-client vim patch curl vim

#### BEGIN: Install PHP extensions recommended for Yii 2.0 Framework

# Install PHP Extension helper
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions soap zip curl bcmath exif gd iconv intl mbstring opcache pdo_mysql imagick sockets http && \
    install-php-extensions @composer-1 && \
    composer clear-cache

# Install composer plugins
RUN composer global require --optimize-autoloader \
        "hirak/prestissimo" && \
    composer global require --dev malukenho/mcbumpface && \
    composer global dumpautoload --optimize && \
    composer clear-cache

# Clean APT Cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#### END: Install PHP extensions recommended for Yii 2.0 Framework

