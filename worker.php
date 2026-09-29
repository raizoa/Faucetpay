<?php

declare(strict_types=1);

echo "=====================================\n";
echo " Railway Cloud Network TEST\n";
echo "=====================================\n";

$appMode = getenv('APP_MODE') ?: 'not-set';

echo "APP_MODE: {$appMode}\n";
echo "PHP: " . PHP_VERSION . "\n";
echo "Container started: " . date('Y-m-d H:i:s') . "\n";

function testUrl(string $url): void
{
    echo "\nTesting: {$url}\n";

    $context = stream_context_create([
        'http' => [
            'timeout' => 10,
            'method' => 'GET',
        ],
        'https' => [
            'timeout' => 10,
            'method' => 'GET',
        ],
    ]);

    $start = microtime(true);

    $result = @file_get_contents($url, false, $context);

    $elapsed = round(microtime(true) - $start, 3);

    if ($result !== false) {
        echo "SUCCESS | {$elapsed}s | " . strlen($result) . " bytes\n";
    } else {
        echo "FAILED | {$elapsed}s\n";
    }
}

testUrl('https://example.com');

echo "\n=====================================\n";
echo "Worker mulai berjalan...\n";
echo "=====================================\n";

while (true) {

    echo "[" . date('Y-m-d H:i:s') . "] Cloud worker aktif\n";

    sleep(60);
}
