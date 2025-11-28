FROM php:8.2-apache
# Install mysqli (and pdo_mysql if you want)
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable Apache mod_rewrite (optional but often useful)
RUN a2enmod rewrite
WORKDIR /var/www/html

# Copy ALL app files from src/ into the container
COPY src/ .
EXPOSE 80
