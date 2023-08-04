FROM ubuntu:latest
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update -y \
    && apt install wget mariadb-server tzdata -y \
    && apt install unzip php apache2 php-mysqlnd -y \
    && apt install openssl -y \
    && mkdir -p /etc/apache2/sslcert \
    && unzip mrsubbu.live.zip -d /etc/apache2/sslcert \
    && wget https://wordpress.org/latest.zip \
    && rm -rf /var/www/html/* \
    && unzip latest.zip -d /var/www/html/ \
    && mv /var/www/html/wordpress/* /var/www/html/ \
    && mv /var/www/html/wp-config-sample.php  /var/www/html/wp-config.php \
    && sed -i 's/database_name_here/wordpress/g' /var/www/html/wp-config.php \
    && sed -i 's/username_here/admin/g' /var/www/html/wp-config.php \
    && sed -i 's/password_here/Qwert123/g' /var/www/html/wp-config.php \
    && sed -i 's/localhost/database-1.cp35ofbjjbaa.us-east-1.rds.amazonaws.com/g' /var/www/html/wp-config.php
RUN a2ensite mrsubbu

COPY mrsubbu.live.zip mrsubbu.live.zip
COPY mrsubbu.conf /etc/apache2/sites-available/
EXPOSE 3306
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
