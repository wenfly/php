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
    pecl install memcached && \
    docker-php-ext-enable memcached
RUN docker-php-ext-install -j$(nproc) sysvmsg  sysvshm bz2 fileinfo calendar exif
    #安装redis
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
     && echo '\n\
        extension = "scws.so" \n\
        scws.default.charset = utf-8 \n\
        scws.default.fpath = /usr/local/scws/etc/' >/usr/local/etc/php/conf.d/docker-php-ext-scws.ini \
     && rm -r /tmp/scws.tar.gz \
     && rm -r /tmp/scws-1.2.3 \
     )
#安装readline
RUN apt-get -y install libncurses-dev \
    && curl -fsSL http://thrysoee.dk/editline/libedit-20181209-3.1.tar.gz -o libedit.tar.gz  \
    && mkdir -p /tmp/libedit \ 
    && tar -xf libedit.tar.gz -C /tmp/libedit  \ 
    && rm -r libedit.tar.gz  \
    && cd /tmp/libedit/libedit-20181209-3.1 \
    && ./configure \
    && make \
    && make install \
    && tar -xf /usr/src/php.tar.xz -C /usr/src/ \
    && cd /usr/src/php-7.3.20/ext/readline \
    #&& cd /usr/src/php/ext/readline \
    && phpize \
    && docker-php-ext-configure /usr/src/php-7.3.20/ext/readline --with-php-config=/usr/local/bin/php-config \
    && docker-php-ext-install  /usr/src/php-7.3.20/ext/readline \
    ##&& docker-php-ext-install /tmp/libedit/libedit-20181209-3.1 \
    && rm -rf /tmp/libedit \
    && rm -rf /usr/src/php-7.3.20
RUN apt-get -y install wget \
    && wget https://github.com/wenfly/soft/raw/master/snowflake-master.tar.gz \
    && tar -xf snowflake-master.tar.gz -C /tmp/ \
    && rm -rf snowflake-master.tar.gz \
    && cd /tmp/snowflake-master \
    && phpize \
    && docker-php-ext-configure /tmp/snowflake-master --with-php-config=/usr/local/bin/php-config \
    && docker-php-ext-install /tmp/snowflake-master \
    && echo '\n\
        [snowflake] \n\
        extension = "snowflake.so" \n\
        snowflake.node = 1' >/usr/local/etc/php/conf.d/docker-php-ext-snowflake.ini \
    && rm -rf /tmp/snowflake-master
    ###安装sphinx
RUN wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.16.tar.gz \
    && tar -xf libiconv-1.16.tar.gz -C /tmp  \
    && rm -rf libiconv-1.16.tar.gz \
    && cd /tmp/libiconv-1.16 \
    && sed -i -e '/gets is a security/d' srclib/stdio.in.h \
    && ./configure --prefix=/usr/local \
    && make \
    && make install \
    && rm -rf /tmp/libiconv-1.16
RUN apt-get -y install mysql-client unixodbc libpq5 \
    && curl -fsSL http://sphinxsearch.com/files/sphinx-2.2.11-release.tar.gz -o sphinx-2.2.11-release.tar.gz \
    && tar -xf sphinx-2.2.11-release.tar.gz -C /tmp/ \
    && rm -rf sphinx-2.2.11-release.tar.gz \
    && cd /tmp/sphinx-2.2.11-release/api/libsphinxclient \
    && ./configure \
    && make \
    && make install \
    && cd /tmp/sphinx-2.2.11-release/ \
    && ./configure --prefix=/usr/local/sphinx \
    && sed -i 's%LIBS = -lexpat -ldl -lm -lz  -L/usr/local/lib -lrt  -lpthread%LIBS = -lexpat -ldl -lm -liconv -lz  -L/usr/local/lib -lrt  -lpthread%g' src/Makefile \
    && make \
    && make install \
    && cp  /usr/local/sphinx/etc/sphinx-min.conf.dist  /usr/local/sphinx/etc/sphinx.conf \
    && cd \
    && rm -rf /tmp/sphinx-2.2.11-release
    ##apt-get clean
 
    
    
