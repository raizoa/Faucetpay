FROM php:8.3-cli

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libcurl4-openssl-dev \
        python3 \
        python3-pip \
    && docker-php-ext-install curl \
    && pip3 install --break-system-packages --no-cache-dir \
        pycryptodome \
        psutil \
        requests \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

WORKDIR /app/TronBlow

CMD ["php", "-r", "echo 'TronBlow runtime ready | PHP '.PHP_VERSION.PHP_EOL; while (true) { sleep(60); }"]
