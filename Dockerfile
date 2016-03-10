FROM debian:latest
MAINTAINER diegomartin dmsgago@gmail.com

RUN apt-get update && apt-get install -y apache2 php5 && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server && \
    apt-get install -y php5-mysql libapache2-mod-php5 wget zip

RUN wget https://releases.wikimedia.org/mediawiki/1.26/mediawiki-1.26.2.tar.gz && \
    tar xzf mediawiki-1.26.2.tar.gz && \
    mv mediawiki-1.26.2 mediawiki && \
    rm -r mediawiki-1.26.2.tar.gz && \
    rm /var/www/html/index.html && \
    mv mediawiki/* /var/www/html/ && \
    chown -R www-data: /var/www/html

ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD script.sh /usr/sbin/script.sh

RUN chmod +x /usr/sbin/script.sh

EXPOSE 80

ENV MYSQL_ROOT_PASSWORD=usuario
ENV MYSQL_DATABASE=mediawikidb
ENV MYSQL_USER=mediawiki
ENV MYSQL_PASSWORD=usuario

ENTRYPOINT ["script.sh"]
