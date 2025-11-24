# Rust Web App 演示脚本
# 此脚本演示完整的 API 使用流程

$baseUrl = "http://127.0.0.1:12306"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Rust Web App API 演示" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查服务器是否运行
Write-Host "检查服务器状态..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/products" -Method GET -ErrorAction Stop
} catch {
    Write-Host "错误: 无法连接到服务器 $baseUrl" -ForegroundColor Red
    Write-Host "请确保服务器已启动 (运行 'cargo run')" -ForegroundColor Red
    exit 1
}
Write-Host "服务器运行正常!" -ForegroundColor Green
Write-Host ""

# 步骤 1: 创建产品 1
Write-Host "步骤 1: 创建产品 - iPhone 15" -ForegroundColor Cyan
$product1Body = @{
    title = "iPhone 15"
    price = @{
        usd = @{
            cents = 99900
        }
    }
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/products" -Method PUT -Body $product1Body -ContentType "application/json"
    $product1Id = $response
    Write-Host "✓ 产品创建成功! ID: $product1Id" -ForegroundColor Green
} catch {
    Write-Host "✗ 创建产品失败: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 步骤 2: 创建产品 2
Write-Host "步骤 2: 创建产品 - MacBook Pro" -ForegroundColor Cyan
$product2Body = @{
    title = "MacBook Pro"
    price = @{
        usd = @{
            cents = 199900
        }
    }
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/products" -Method PUT -Body $product2Body -ContentType "application/json"
    $product2Id = $response
    Write-Host "✓ 产品创建成功! ID: $product2Id" -ForegroundColor Green
} catch {
    Write-Host "✗ 创建产品失败: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 步骤 3: 查询产品 1
Write-Host "步骤 3: 查询产品 1" -ForegroundColor Cyan
try {
    $product = Invoke-RestMethod -Uri "$baseUrl/products/$product1Id" -Method GET
    Write-Host "✓ 产品信息:" -ForegroundColor Green
    Write-Host "  标题: $($product.title)" -ForegroundColor White
    Write-Host "  价格: $($product.price.usd.cents) 美分" -ForegroundColor White
} catch {
    Write-Host "✗ 查询产品失败: $_" -ForegroundColor Red
}
Write-Host ""

# 步骤 4: 创建客户
Write-Host "步骤 4: 创建客户" -ForegroundColor Cyan
$customerBody = @{} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/customers" -Method PUT -Body $customerBody -ContentType "application/json"
    $customerId = $response
    Write-Host "✓ 客户创建成功! ID: $customerId" -ForegroundColor Green
} catch {
    Write-Host "✗ 创建客户失败: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 步骤 5: 创建订单
Write-Host "步骤 5: 创建订单" -ForegroundColor Cyan
$orderBody = @{
    customer = $customerId
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/orders" -Method PUT -Body $orderBody -ContentType "application/json"
    $orderId = $response
    Write-Host "✓ 订单创建成功! ID: $orderId" -ForegroundColor Green
} catch {
    Write-Host "✗ 创建订单失败: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 步骤 6: 向订单添加产品 1
Write-Host "步骤 6: 向订单添加 iPhone 15 (数量: 2)" -ForegroundColor Cyan
$addProductBody = @{
    quantity = 2
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/orders/$orderId/products/$product1Id" -Method POST -Body $addProductBody -ContentType "application/json"
    Write-Host "✓ 产品已添加到订单! 行项 ID: $response" -ForegroundColor Green
} catch {
    Write-Host "✗ 添加产品失败: $_" -ForegroundColor Red
}
Write-Host ""

# 步骤 7: 向订单添加产品 2
Write-Host "步骤 7: 向订单添加 MacBook Pro (数量: 1)" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/orders/$orderId/products/$product2Id" -Method POST -Body $addProductBody -ContentType "application/json"
    Write-Host "✓ 产品已添加到订单! 行项 ID: $response" -ForegroundColor Green
} catch {
    Write-Host "✗ 添加产品失败: $_" -ForegroundColor Red
}
Write-Host ""

# 步骤 8: 查询订单
Write-Host "步骤 8: 查询订单详情" -ForegroundColor Cyan
try {
    $order = Invoke-RestMethod -Uri "$baseUrl/orders/$orderId" -Method GET
    Write-Host "✓ 订单信息:" -ForegroundColor Green
    Write-Host "  订单 ID: $($order.id)" -ForegroundColor White
    Write-Host "  行项数量: $($order.line_items.Count)" -ForegroundColor White
    foreach ($item in $order.line_items) {
        Write-Host "    - $($item.title) x $($item.quantity) ($($item.price.usd.cents) 美分/件)" -ForegroundColor Gray
    }
} catch {
    Write-Host "✗ 查询订单失败: $_" -ForegroundColor Red
}
Write-Host ""

# 步骤 9: 查询客户（包含订单）
Write-Host "步骤 9: 查询客户信息（包含订单）" -ForegroundColor Cyan
try {
    $customer = Invoke-RestMethod -Uri "$baseUrl/customers/$customerId" -Method GET
    Write-Host "✓ 客户信息:" -ForegroundColor Green
    Write-Host "  客户 ID: $($customer.id)" -ForegroundColor White
    Write-Host "  订单数量: $($customer.orders.Count)" -ForegroundColor White
} catch {
    Write-Host "✗ 查询客户失败: $_" -ForegroundColor Red
}
Write-Host ""

# 步骤 10: 更新产品标题
Write-Host "步骤 10: 更新产品标题" -ForegroundColor Cyan
$newTitle = "iPhone 15 Pro"
# PowerShell 中的 URL 编码
$encodedTitle = [System.Uri]::EscapeDataString($newTitle)
try {
    Invoke-RestMethod -Uri "$baseUrl/products/$product1Id/title/$encodedTitle" -Method POST | Out-Null
    Write-Host "✓ 产品标题已更新为: $newTitle" -ForegroundColor Green
    
    # 验证更新
    $updatedProduct = Invoke-RestMethod -Uri "$baseUrl/products/$product1Id" -Method GET
    Write-Host "  验证: 当前标题 = $($updatedProduct.title)" -ForegroundColor Gray
} catch {
    Write-Host "✗ 更新产品标题失败: $_" -ForegroundColor Red
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "演示完成!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

