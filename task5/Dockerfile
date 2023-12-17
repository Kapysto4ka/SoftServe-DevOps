FROM alpine:latest

RUN apk update && \
    apk add apache2 && \
    rm -rf /var/cache/apk/*

WORKDIR /var/www/html

RUN echo "<h1>Hello World!</h1>" > index.html

RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]

