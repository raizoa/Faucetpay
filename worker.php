<?php

echo "=====================================\n";
echo " Railway PHP Worker TEST\n";
echo "=====================================\n";

echo "Container started: " . date('Y-m-d H:i:s') . "\n";

while (true) {

    echo "[" . date('Y-m-d H:i:s') . "] Worker masih berjalan...\n";

    sleep(60);
}
