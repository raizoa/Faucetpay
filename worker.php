<?php

echo "=====================================\n";
echo " Railway PHP Worker\n";
echo "=====================================\n";

$appMode = getenv('APP_MODE') ?: 'not-set';

echo "APP_MODE: " . $appMode . "\n";
echo "Container started: " . date('Y-m-d H:i:s') . "\n";

while (true) {
    echo "[" . date('Y-m-d H:i:s') . "] Worker masih berjalan...\n";
    sleep(60);
}
