<?php
error_reporting(0);
date_default_timezone_set('Asia/Jakarta');

// ======================= KONFIGURASI =======================
$CONFIG_FILE = __DIR__ . "/tronblow_config.json";
$COOKIE_FILE = __DIR__ . "/cookies_tronblow.txt";

// ======================= WARNA =======================
const GOLD   = "\033[38;5;220m";
const L_GOLD = "\033[1;33m";
const GREEN  = "\033[1;32m";
const CYAN   = "\033[1;36m";
const RED    = "\033[1;31m";
const WHITE  = "\033[1;37m";
const RESET  = "\033[0m";
const BOLD   = "\033[1m";

// ======================= FUNGSI UI =======================
function typewrite($text, $speed = 15000) {
    $length = mb_strlen($text);
    for ($i = 0; $i < $length; $i++) {
        echo mb_substr($text, $i, 1);
        @ob_flush(); @flush();
        usleep($speed);
    }
    echo "\n";
}

function clear() { (PHP_OS == "Linux") ? system('clear') : pclose(popen('cls', 'w')); }

function hacker_intro() {
    clear();
    echo "\n" . GREEN;
    typewrite("[+] Initializing TronBlow Protocol...", 15000);
    typewrite("[+] Bypassing security...", 15000);
    typewrite("[+] System Ready & Online!", 15000);
    echo RESET . "\n";
}

function banner() {
    clear();
    $t1 = "         TRONBLOW Remake         ";
    $t2 = "    Credit to: ScriptyXsouu    ";
    $t3 = "  https://t.me/+f3QBLkR5D8k4YzNl  ";
    
    $max_len = max(mb_strwidth($t1), mb_strwidth($t2), mb_strwidth($t3));
    $border = str_repeat("─", $max_len + 2);

    echo "\n";
    echo CYAN . "  ╭" . $border . "╮\n";
    echo CYAN . "  │ " . L_GOLD . BOLD . $t1 . str_repeat(" ", $max_len - mb_strwidth($t1)) . CYAN . " │\n";
    echo CYAN . "  │ " . WHITE . $t2 . str_repeat(" ", $max_len - mb_strwidth($t2)) . CYAN . " │\n";
    echo CYAN . "  │ " . CYAN . $t3 . str_repeat(" ", $max_len - mb_strwidth($t3)) . CYAN . " │\n";
    echo CYAN . "  ╰" . $border . "╯\n" . RESET;
}

function timer($seconds, $prefix = "⏳ Next claim") {
    $total_blocks = 10;
    for ($i = 0; $i <= $seconds; $i++) {
        $progress = ($i / $seconds);
        $num_blocks = (int)($progress * $total_blocks);
        $bar = str_repeat("■", $num_blocks) . str_repeat(" ", $total_blocks - $num_blocks);
        $percent = (int)($progress * 100);
        echo "\r" . WHITE . $prefix . " [" . $bar . "] " . $percent . "%" . RESET;
        @ob_flush(); @flush();
        if ($i < $seconds) sleep(1);
    }
    echo "\n";
}

// ======================= FUNGSI BOT & CAPTCHA =======================
function fetch_page($url, $cookie_file) {
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true, CURLOPT_FOLLOWLOCATION => true, CURLOPT_TIMEOUT => 30,
        CURLOPT_SSL_VERIFYPEER => false, CURLOPT_COOKIEJAR => $cookie_file, CURLOPT_COOKIEFILE => $cookie_file,
        CURLOPT_USERAGENT => 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36'
    ]);
    $html = curl_exec($ch);
    return ['html' => $html, 'code' => curl_getinfo($ch, CURLINFO_HTTP_CODE)];
}

function extract_csrf_token(string $html): ?string {
    if (preg_match('/<input\s+type="hidden"\s+name="csrf_token"\s+value="([^"]+)"/i', $html, $m)) {
        return $m[1];
    }
    return null;
}

function extract_math_question(string $html): ?array {
    if (preg_match('/<div\s+class="captcha-q">(.*?)<\/div>/is', $html, $m)) {
        $text = strip_tags($m[1]);
        $text = html_entity_decode($text, ENT_QUOTES | ENT_HTML5, 'UTF-8');
        $text = trim($text);
    } else {
        $text = strip_tags($html);
        $text = html_entity_decode($text, ENT_QUOTES | ENT_HTML5, 'UTF-8');
    }

    $text = str_replace(['−', '–', '—', '‐', '‑', '‒', '&minus;'], '-', $text);
    $text = str_replace(['×', '&times;'], '*', $text);
    $text = str_replace(['÷', '&divide;'], '/', $text);

    if (preg_match('/what\s+is\s+(\d+)\s*([+\-*\/])\s*(\d+)\s*=\s*\?/i', $text, $m)) {
        return ['q1' => (int)$m[1], 'op' => $m[2], 'q2' => (int)$m[3]];
    }
    if (preg_match('/(\d+)\s*([+\-*\/])\s*(\d+)\s*=\s*\?/i', $text, $m)) {
        return ['q1' => (int)$m[1], 'op' => $m[2], 'q2' => (int)$m[3]];
    }
    if (preg_match('/(\d+)\s*([+\-*\/])\s*(\d+)\s*=/i', $text, $m)) {
        return ['q1' => (int)$m[1], 'op' => $m[2], 'q2' => (int)$m[3]];
    }
    return null;
}

function solve_math(array $math): int {
    $n1 = $math['q1'];
    $n2 = $math['q2'];
    switch ($math['op']) {
        case '+': return $n1 + $n2;
        case '-': return $n1 - $n2;
        case '*': return $n1 * $n2;
        case '/': return $n2 != 0 ? (int)($n1 / $n2) : 0;
        default: return 0;
    }
}

function submit_claim($url, $cookie_file, $email, $csrf, $ans) {
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_POST => true, CURLOPT_POSTFIELDS => http_build_query(['action'=>'claim', 'csrf_token'=>$csrf, 'email'=>$email, 'math_answer'=>$ans]),
        CURLOPT_RETURNTRANSFER => true, CURLOPT_FOLLOWLOCATION => true, CURLOPT_COOKIEJAR => $cookie_file, CURLOPT_COOKIEFILE => $cookie_file
    ]);
    return curl_exec($ch);
}

// ======================= MAIN LOOP =======================
hacker_intro();
banner();

if (file_exists($CONFIG_FILE)) {
    $config = json_decode(file_get_contents($CONFIG_FILE), true);
}

if (empty($config['email'])) {
    echo GREEN . "Masukkan Email FaucetPay: " . RESET; 
    $config['email'] = trim(fgets(STDIN));
    $config['base_url'] = 'https://tronblow.site';
    file_put_contents($CONFIG_FILE, json_encode($config));
}

echo WHITE . " Account : " . L_GOLD . $config['email'] . RESET . "\n\n";

while (true) {
    $res = fetch_page($config['base_url'], $COOKIE_FILE);
    
    $csrf = extract_csrf_token($res['html']);
    $math = extract_math_question($res['html']);
    $ans = $math ? solve_math($math) : 0;

    $log_time = WHITE . "[" . date("H:i:s") . "] ";

    if ($math) {
        typewrite($log_time . CYAN . "[Captcha] {$math['q1']} {$math['op']} {$math['q2']} = $ans" . RESET, 10000);
    }

    if ($csrf && $math !== null) {
        $out = submit_claim($config['base_url'], $COOKIE_FILE, $config['email'], $csrf, $ans);
        if (strpos(strtolower($out), 'success') !== false || strpos(strtolower($out), 'claimed') !== false) {
            typewrite($log_time . WHITE . "✅ Success! Good Job Bro" . RESET, 15000);
            typewrite(GREEN . "Reward 1000 satoshi sent to your FaucetPay" . RESET, 15000);
        } else {
            typewrite($log_time . RED . "❌ Failed/Cooldown!" . RESET, 15000);
        }
    } else {
        typewrite($log_time . RED . "❌ Gagal Bypass Cuk! Coba lagi ya." . RESET, 15000);
    }

    timer(65, "⏳ Next claim");
    typewrite(GOLD . "─────────────────────────────" . RESET, 10000);
}
?>
