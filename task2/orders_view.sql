CREATE OR REPLACE VIEW analysis.v_orders AS
WITH last_order_status as(
SELECT 
	t.order_id as order_id,
	t.status_id as status_id	
FROM (
	SELECT 
		order_id,
		status_id,
		ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY dttm DESC) as row_num
	FROM production.orderstatuslog
	) t
WHERE
	t.row_num = 1
)

SELECT 
	t1.order_id as order_id, 
	t1.order_ts as order_ts, 
	t1.user_id as user_id, 
	t1.bonus_payment as bonus_payment, 
	t1.payment as payment, 
	t1.cost as cost, 
	t1.bonus_grant as bonus_grant, 
	t2.status_id as status
	FROM production.orders t1
	LEFT JOIN last_order_status t2 ON t1.order_id = t2.order_id;
	