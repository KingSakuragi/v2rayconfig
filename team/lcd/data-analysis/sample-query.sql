-- 示例：查询最近7天每日订单量和GMV
SELECT
    dt,
    COUNT(DISTINCT order_id) AS order_cnt,
    SUM(amount) AS gmv
FROM dwd_order_detail
WHERE dt >= date_sub(current_date(), 7)
  AND status = 2
GROUP BY dt
ORDER BY dt;
