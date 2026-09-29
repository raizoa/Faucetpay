FROM php:8.3-cli

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       libcurl4-openssl-dev \
    && docker-php-ext-install curl \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

WORKDIR /app/TronBlow

CMD ["php", "-r", "echo 'TronBlow runtime ready | PHP=' . PHP_VERSION . PHP_EOL; while (true) { sleep(60); }"]
