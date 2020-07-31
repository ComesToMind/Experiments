FROM centos:7
RUN set -x && yum -y update && yum -y install epel-release
RUN set -x && yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
           && yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm \
           && yum -y install git \
           && yum -y install yum-utils \
           && yum-config-manager --enable remi-php74 \
           && yum -y install php php-fpm php-common php-xml php-mbstring php-json php-zip gcc-c++ make

RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash -
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
RUN npm run production
EXPOSE 8080
CMD ["tail", "-f", "/dev/null"]