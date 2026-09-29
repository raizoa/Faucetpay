FROM php:8.3-cli

WORKDIR /app

COPY worker.php /app/worker.php

CMD ["php", "/app/worker.php"]
