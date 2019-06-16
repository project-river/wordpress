FROM debian:jessie
RUN apt-get update
RUN apt-get -y install  php5 php5-mysql
RUN apt-get update && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]
COPY default.conf /etc/nginx/conf.d/default.conf
WORKDIR /etc/nginx
RUN cd /var/www
RUN apt-get install wget -y
RUN wget http://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz -C /var/www/
RUN cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
RUN sed -i 's/database_name_here/wordpress/' /var/www/wordpress/wp-config.php
RUN sed -i 's/username_here/wordpress_user/' /var/www/wordpress/wp-config.php
RUN sed -i 's/password_here/dev@admin123/' /var/www/wordpress/wp-config.php
RUN sed -i 's/localhost/10.0.2.246/g' /var/www/wordpress/wp-config.php
#RUN cd /etc/apache2/sites-enabled/
#RUN sed -i 's/\/var\/www\/html/\/var\/www\/wordpress/' /etc/apache2/sites-enabled/000-default.conf
#CMD [apache2ctl -DFOREGROUND]
#COPY run.sh .
#RUN chmod 0500 run.sh
CMD [ nginx ]
