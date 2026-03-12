## 常用表字典

### dwd_order_detail（订单明细表）
| 字段 | 类型 | 说明 |
|------|------|------|
| order_id | STRING | 订单ID |
| user_id | STRING | 用户ID |
| amount | DECIMAL | 订单金额 |
| status | INT | 状态：1-待支付 2-已支付 3-已取消 |
| created_at | TIMESTAMP | 创建时间 |
| dt | STRING | 分区字段，格式 yyyy-MM-dd |

### dim_user（用户维度表）
| 字段 | 类型 | 说明 |
|------|------|------|
| user_id | STRING | 用户ID |
| user_name | STRING | 用户名 |
| register_date | STRING | 注册日期 |
| level | INT | 用户等级 |
