FROM centos:7
MAINTAINER FengZhiHui

COPY redis-4.0.0.tgz /root/
COPY libmcrypt-2.5.8-13.el7.x86_64.rpm /root/
ADD php-7.2.3.tar.gz /root/

RUN yum install -y gcc-c++ gd-devel pcre-devel libxml2 libxml2-devel openssl-devel \
        libcurl-devel ncurses-devel libicu libicu-devel perl-DBD-MySQL \
        make autoconf /root/libmcrypt-2.5.8-13.el7.x86_64.rpm \
    && yum clean all \
    && cd /root/php-7.2.3/ \
    && ./configure \
        --prefix=/opt/php \
        --enable-fpm \
        --with-config-file-path=/etc \
        --enable-ftp \
        --enable-mbstring \
        --with-pdo-mysql \
        --enable-pcntl \
        --enable-soap \
        --enable-sockets \
        --enable-mysqlnd \
        --enable-zip \
        --with-zlib \
        --with-gd \
        --with-jpeg-dir \
        --with-png-dir \
        --with-freetype-dir \
        --enable-gd-native-ttf \
        --enable-wddx \
        --with-mcrypt \
        --with-openssl \
        --with-openssl-dir \
        --enable-opcache \
        --with-gettext \
        --enable-bcmath \
        --with-curl \
        --enable-intl \
        --enable-sysvsem \
        --enable-sysvshm \
    && make -j8 && make install \
    && /opt/php/bin/pecl install -o -f /root/redis-4.0.0.tgz \
    && mkdir -p /var/www/html/ \
    && chown -R nobody.nobody /var/www/html/ \
    && rm -rf /root/php-7.2.3/

COPY scripts/php-fpm /etc/init.d/php-fpm
COPY conf/php.ini /etc/php.ini
COPY conf/php-fpm.conf /opt/php/etc/php-fpm.conf

EXPOSE 9000
ENTRYPOINT ["/etc/init.d/php-fpm"]
CMD ["start"]
