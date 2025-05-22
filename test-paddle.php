<?php
require __DIR__ . '/vendor/autoload.php';

use Paddle\SDK\PaddleClient;

// Substitua pela sua chave real de API (sandbox)
$apiKey = 'pdl_sdbx_apikey_01jvwrfbt4ge53ektp3p3xzeb6_MFsh4gGEsNYNb71GJTwcQt_ArM';

$client = PaddleClient::make($apiKey);

try {
    // Exemplo: obter lista de produtos do Paddle
    $products = $client->products->list();
    echo "<pre>";
    print_r($products);
    echo "</pre>";
} catch (Exception $e) {
    echo "Erro ao conectar no Paddle: " . $e->getMessage();
}