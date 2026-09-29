<?php

echo "=====================================\n";
echo " Railway AUTO-RESTART TEST\n";
echo "=====================================\n";

$start = time();

while (true) {

    $elapsed = time() - $start;

    echo "[" . date('Y-m-d H:i:s') . "] Worker berjalan... {$elapsed} detik\n";

    /*
     * Setelah 60 detik, sengaja crash.
     * exit code 1 = failure
     * Railway seharusnya melakukan restart.
     */
    if ($elapsed >= 60) {
        echo "[" . date('Y-m-d H:i:s') . "] SIMULASI CRASH - exit(1)\n";
        exit(1);
    }

    sleep(10);
}
