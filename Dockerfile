FROM alpine:3.14

RUN apk add --no-cache \
  apache2 \
  apache2-utils \
  apache2-ssl \
  apache2-proxy \
  php7-apache2 \
  php7-curl \
  php7-json \
  php7-openssl

RUN mkdir -p /var/log/apache2

RUN sed -i 's|#LoadModule rewrite_module modules/mod_rewrite.so|LoadModule rewrite_module modules/mod_rewrite.so|g' /etc/apache2/httpd.conf
RUN sed -i 's|DirectoryIndex index.html|DirectoryIndex index.php index.html|g' /etc/apache2/httpd.conf
RUN sed -i 's| logs/error.log| /var/log/apache2/error.log|g' /etc/apache2/httpd.conf
RUN sed -i 's| logs/access.log| /var/log/apache2/access.log|g' /etc/apache2/httpd.conf
RUN sed -i 's|/var/www/localhost/htdocs|/app/www|g' /etc/apache2/httpd.conf

RUN sed -i 's|ErrorLog logs/ssl_error.log|ErrorLog /var/log/apache2/error.log|g' /etc/apache2/conf.d/ssl.conf
RUN sed -i 's|TransferLog logs/ssl_access.log|TransferLog /var/log/apache2/access.log|g' /etc/apache2/conf.d/ssl.conf
RUN sed -i 's|/var/www/localhost/htdocs|/app/www|g' /etc/apache2/conf.d/ssl.conf
RUN sed -i 's|SSLCertificateFile /etc/ssl/apache2/server.pem|SSLCertificateFile /app/ssl/cert.pem|g' /etc/apache2/conf.d/ssl.conf
RUN sed -i 's|SSLCertificateKeyFile /etc/ssl/apache2/server.key|SSLCertificateKeyFile /app/ssl/privkey.pem|g' /etc/apache2/conf.d/ssl.conf
RUN sed -i 's|#SSLCertificateChainFile /etc/ssl/apache2/server-ca.pem|SSLCertificateChainFile /app/ssl/fullchain.pem|g' /etc/apache2/conf.d/ssl.conf

WORKDIR /app

CMD /usr/sbin/httpd -D FOREGROUND
