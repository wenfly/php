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
    pecl install memcached && \
    docker-php-ext-enable memcached #&& \
#RUN docker-php-ext-configure sysvmsg --with-php-config=/usr/local/bin/php-config && \
RUN docker-php-ext-install -j$(nproc) sysvmsg  sysvshm bz2 fileinfo calendar exif
    #安装redisN
RUN pecl install redis-5.0.0 && docker-php-ext-enable redis
    
RUN  curl -fsSL http://www.xunsearch.com/scws/down/scws-1.2.3.tar.bz2 -o /tmp/scws.tar.gz  \
     && ( \
     cd /tmp \
     && tar -xf scws.tar.gz  \
     && cd scws-1.2.3  \
     && ./configure --prefix=/usr/local/scws  \
     && make && make install \
     && cd ./phpext/ \
     && /usr/local/bin/phpize \
     && ./configure --with-php-config=/usr/local/bin/php-config \
     && make \
     && make install \
     && cd /usr/local/scws/etc \
     && curl -fsSL http://www.xunsearch.com/scws/down/scws-dict-chs-gbk.tar.bz2  -o scws-dict-chs-gbk.tar.bz2 \
     && curl -fsSL http://www.xunsearch.com/scws/down/scws-dict-chs-utf8.tar.bz2 -o scws-dict-chs-utf8.tar.bz2 \
     && tar -jxvf scws-dict-chs-utf8.tar.bz2 \
     && tar -jxvf scws-dict-chs-gbk.tar.bz2 \
     && echo $' \n\
     && extension = "scws.so" \n\
     && scws.default.charset = utf-8 \n\
     && scws.default.fpath = /usr/local/scws/etc/' >>/usr/local/etc/php/conf.d/docker-php-ext-scws.ini \
     && rm -r /tmp/scws.tar.gz \
     && rm -r /tmp/scws-1.2.3 \
     )
#安装readline
RUN apt-get install libncurses-dev \
    && curl -fsSL http://thrysoee.dk/editline/libedit-20181209-3.1.tar.gz -o libedit.tar.gz  \
    && mkdir -p /tmp/libedit \ 
    && tar -xf libedit.tar.gz -C /tmp/libedit  \ 
    && rm -r libedit.tar.gz  \
    && cd /tmp/libedit/libedit-20181209-3.1 \
    && ./configure \
    && make \
##    docker-php-ext-configure /tmp/libedit  --with-php-config=/usr/local/bin/php-config && \ 
##    docker-php-ext-install -j$(nproc) /tmp/libedit && \ 
    && rm -rf /tmp/libedit
#RUN echo '[scws]
#          extension = "scws.so"
#          scws.default.charset = utf-8
#          scws.default.fpath = /usr/local/scws/etc/' >>/usr/local/etc/php/conf.d/docker-php-ext-scws.ini
#     #&& docker-php-ext-configure /home/scws-1.2.3/phpext --with-php-config=/usr/local/bin/php-config \
#     #&& docker-php-ext-install /home/scws-1.2.3/phpext

     
 
    
    
