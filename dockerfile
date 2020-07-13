FROM php:7.3-fpm 
RUN apt-get update && \ 
    apt-get -y install libgmp-dev && \ 
    docker-php-ext-install gmp && \ 
    apt-get install -y \ 
    libmagickwand-dev --no-install-recommends && \ 
    #pecl install imagick && \ 
    #docker-php-ext-enable imagick 
    curl -fsSL https://pecl.php.net/get/imagick-3.4.3.tgz -o imagick.tar.gz && \ 
    mkdir -p /tmp/imagick && \ 
    tar -xf imagick.tar.gz -C /tmp/imagick --strip-components=1 && \ 
    rm imagick.tar.gz && \ 
    docker-php-ext-configure /tmp/imagick --with-php-config=/usr/local/bin/php-config && \ 
    docker-php-ext-install /tmp/imagick && \ 
    rm -r /tmp/imagick
