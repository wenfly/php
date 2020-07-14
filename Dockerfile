FROM php:7.3-fpm 
RUN apt-get update && \ 
    apt-get -y install libgmp-dev libmemcached-dev && \ 
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
    rm -r /tmp/imagick && \
    #memcached
    echo "memcached................" && \
    #test1
    #curl -fsSL https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcached/memcached-1.4.7.tar.gz -o memcached.tar.gz && \ 
    #mkdir -p /tmp/memcached && \ 
    #tar -xf memcached.tar.gz -C /tmp/memcached --strip 1 && \ 
    #( \
    # cd /tmp/memcached && \
    # #/usr/local/bin/phpize  && \
    # ./configure && \
    # make -j$(nproc) && \
    # make install \
    # ) && \
    # rm -r /tmp/memcached && \
    # rm /tmp/memcached.tar.gz && \
    # docker-php-ext-enable memcached
    #test1 end
     
    #rm memcached.tar.gz && \ 
    #docker-php-ext-configure memcached --with-libevent=/usr/local/lib && \ 
    #docker-php-ext-install memcached #&& \ 
    #rm -r /tmp/memcached
    pecl install memcached-3.0.4 && \
    docker-php-ext-enable memcached-3.0.4 #&& \
    ##install libmemcached
    #curl -fsSL https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz -o libmemcached.tar.gz && \
    #mkdir -p /tmp/libmemcached && \
    #tar -xf libmemcached.tar.gz -C /tmp/libmemcached && \
    #docker-php-ext-configure /tmp/libmemcached --prefix=/usr/local/libmemcached --with-memcached && \
    #docker-php-ext-install  /tmp/libmemcached && \
    #rm -r libmemcached.tar.gz && /tmp/libmemcached
    
    
