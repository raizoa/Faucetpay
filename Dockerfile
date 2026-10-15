FROM php:8.3-cli

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libcurl4-openssl-dev \
        python3 \
        python3-pip \
        python3-venv \
        curl \
    && docker-php-ext-install curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

RUN uv python install 3.14 \
    && uv venv --python 3.14 /opt/venv

ENV PATH="/opt/venv/bin:${PATH}"

RUN uv pip install --no-cache \
    bcrypt==4.2.0 \
    certifi==2026.7.22 \
    charset-normalizer==3.5.2 \
    colorama==0.4.6 \
    cryptography==43.0.0 \
    idna==3.20 \
    numpy==2.5.3 \
    opencv-python-headless==5.0.0.93 \
    packaging==25.0 \
    pillow==12.3.0 \
    psutil==7.2.2 \
    pycryptodome==3.23.0 \
    pyfiglet==1.0.3 \
    requests==2.34.2 \
    urllib3==2.8.0 \
    wheel==0.46.1

COPY . /app

WORKDIR /app/

CMD ["php", "-r", "echo 'TronBlow runtime ready | PHP '.PHP_VERSION.PHP_EOL; while (true) { sleep(60); }"]
