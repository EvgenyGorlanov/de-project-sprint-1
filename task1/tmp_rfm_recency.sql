DROP TABLE IF EXISTS analysis.tmp_rfm_recency;
CREATE TABLE analysis.tmp_rfm_recency (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);
INSERT INTO analysis.tmp_rfm_recency
SELECT 
    u.id AS user_id,
    ntile(5) OVER (ORDER BY max(o.order_ts) NULLS FIRST) AS recency
FROM 
    analysis.v_users AS u
LEFT JOIN
    analysis.v_orders AS o 
        ON u.id = o.user_id
        AND o.status = (SELECT id FROM analysis.v_orderstatuses WHERE key = 'Closed')
        AND EXTRACT (YEAR FROM o.order_ts) >= 2022
GROUP BY u.id 

