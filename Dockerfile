FROM centos:7
RUN set -x && yum -y update && yum -y install epel-release
RUN set -x && yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
           && yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm \
           && yum -y install git \
           && yum -y install supervisor \
           && yum -y install yum-utils \
           && yum-config-manager --enable remi-php74 \
           && yum -y install php php-fpm php-common php-xml php-mbstring php-json php-zip

RUN yum install -y gcc-c++ make && curl -sL https://rpm.nodesource.com/setup_14.x | bash -
RUN yum install -y nodejs

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
WORKDIR /var/www/html

RUN git clone https://github.com/Saritasa/simplephpapp.git .

RUN composer install

ADD .env .

RUN php artisan key:generate

RUN npm install
RUN set -x && mkdir /run/php-fpm/ \
           && touch /run/php-fpm/php-fpm.pid \
           && sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php-fpm.conf
RUN yum -y install httpd
RUN npm run production
# RUN chown -R apache:apache /usr/share/nginx
# RUN chown -R apache:apache /etc/php*
# RUN sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
# RUN sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf
RUN sed -i 's/DocumentRoot "/var/www/html"/DocumentRoot "/var/www/html/public"/g' /etc/httpd/conf/httpd.conf
ADD supervisor.conf /etc/supervisor.conf
EXPOSE 8080
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
