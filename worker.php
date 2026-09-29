<?php

declare(strict_types=1);

echo "=====================================\n";
echo " RAILWAY PHP CLOUD WORKER\n";
echo "=====================================\n";

$appMode = getenv('APP_MODE') ?: 'production';

$startTime = time();
$counter = 0;

echo "APP_MODE : {$appMode}\n";
echo "PHP      : " . PHP_VERSION . "\n";
echo "OS       : " . PHP_OS . "\n";
echo "START    : " . date('Y-m-d H:i:s') . "\n";

function formatBytes(int $bytes): string
{
    if ($bytes >= 1024 * 1024) {
        return round($bytes / 1024 / 1024, 2) . ' MB';
    }

    if ($bytes >= 1024) {
        return round($bytes / 1024, 2) . ' KB';
    }

    return $bytes . ' B';
}

function testInternet(): bool
{
    $url = 'https://example.com';

    $context = stream_context_create([
        'http' => [
            'timeout' => 10,
            'method' => 'GET',
        ],
    ]);

    $start = microtime(true);

    $result = @file_get_contents($url, false, $context);

    $elapsed = round(microtime(true) - $start, 3);

    if ($result !== false) {
        echo "Internet : ONLINE | {$elapsed}s | "
            . strlen($result)
            . " bytes\n";

        return true;
    }

    echo "Internet : FAILED | {$elapsed}s\n";

    return false;
}

echo "\nInitial network test:\n";
testInternet();

echo "\n=====================================\n";
echo " WORKER STARTED\n";
echo "=====================================\n";

while (true) {

    $counter++;

    $uptime = time() - $startTime;

    $memory = memory_get_usage(true);
    $peakMemory = memory_get_peak_usage(true);

    echo "["
        . date('Y-m-d H:i:s')
        . "] ";

    echo "RUN #{$counter}";

    echo " | Uptime: {$uptime}s";

    echo " | RAM: "
        . formatBytes($memory);

    echo " | Peak: "
        . formatBytes($peakMemory);

    echo "\n";

    /*
     * Tes koneksi setiap 5 menit.
     */
    if ($counter % 5 === 0) {
        testInternet();
    }

    sleep(60);
}
