FROM php:8.3-cli

WORKDIR /app

RUN docker-php-ext-install curl

COPY . /app

WORKDIR /app/TronBlow

CMD ["php", "-r", "echo 'TronBlow runtime ready | PHP=' . PHP_VERSION . PHP_EOL;"]
