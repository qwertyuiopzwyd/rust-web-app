# 项目运行和演示指南

## 运行项目

### 1. 启动服务器

在项目根目录运行：

```bash
cargo run
```

服务器将在 `http://127.0.0.1:12306` 启动。

### 2. 运行测试

```bash
cargo test
```

## API 演示

### 基础信息

- **服务器地址**: `http://127.0.0.1:12306`
- **API 格式**: JSON
- **货币格式**: `{ "usd": { "cents": 123 } }` (123 美分 = $1.23)

### API 端点列表

#### 产品 (Products)

1. **创建产品** - `PUT /products`
2. **获取产品** - `GET /products/<id>`
3. **设置产品标题** - `POST /products/<id>/title/<title>`

#### 订单 (Orders)

1. **创建订单** - `PUT /orders`
2. **获取订单** - `GET /orders/<id>`
3. **添加/更新订单中的产品** - `POST /orders/<id>/products/<product_id>`
4. **获取订单行项** - `GET /orders/<id>/line-items/<line_item_id>`

#### 客户 (Customers)

1. **创建客户** - `PUT /customers`
2. **获取客户（含订单）** - `GET /customers/<id>`

## 完整演示流程

### 步骤 1: 创建产品

```bash
curl -X PUT http://127.0.0.1:12306/products \
  -H "Content-Type: application/json" \
  -d '{
    "title": "iPhone 15",
    "price": {
      "usd": {
        "cents": 99900
      }
    }
  }'
```

响应示例：
```json
"550e8400-e29b-41d4-a716-446655440000"
```

保存返回的产品 ID（例如：`550e8400-e29b-41d4-a716-446655440000`）

### 步骤 2: 创建另一个产品

```bash
curl -X PUT http://127.0.0.1:12306/products \
  -H "Content-Type: application/json" \
  -d '{
    "title": "MacBook Pro",
    "price": {
      "usd": {
        "cents": 199900
      }
    }
  }'
```

保存返回的产品 ID。

### 步骤 3: 查询产品

```bash
curl http://127.0.0.1:12306/products/<产品ID>
```

### 步骤 4: 创建客户

```bash
curl -X PUT http://127.0.0.1:12306/customers \
  -H "Content-Type: application/json" \
  -d '{}'
```

响应示例：
```json
"660e8400-e29b-41d4-a716-446655440000"
```

保存返回的客户 ID。

### 步骤 5: 创建订单

```bash
curl -X PUT http://127.0.0.1:12306/orders \
  -H "Content-Type: application/json" \
  -d '{
    "customer": "<客户ID>"
  }'
```

保存返回的订单 ID。

### 步骤 6: 向订单添加产品

```bash
curl -X POST http://127.0.0.1:12306/orders/<订单ID>/products/<产品ID> \
  -H "Content-Type: application/json" \
  -d '{
    "quantity": 2
  }'
```

### 步骤 7: 查询订单

```bash
curl http://127.0.0.1:12306/orders/<订单ID>
```

### 步骤 8: 查询客户（包含订单信息）

```bash
curl http://127.0.0.1:12306/customers/<客户ID>
```

### 步骤 9: 更新产品标题

```bash
curl -X POST http://127.0.0.1:12306/products/<产品ID>/title/iPhone%2015%20Pro
```

## 使用 PowerShell 演示脚本

项目根目录包含 `demo.ps1` 脚本，可以自动执行完整的演示流程。

运行方式：
```powershell
.\demo.ps1
```

## 注意事项

1. **货币格式**: 价格以美分（cents）为单位，例如：
   - $1.23 = 123 cents
   - $999.00 = 99900 cents
   - $1999.00 = 199900 cents

2. **ID 格式**: 所有 ID 都是 UUID 格式的字符串

3. **数量限制**: 订单中的产品数量必须大于 0

4. **标题限制**: 产品标题不能为空

