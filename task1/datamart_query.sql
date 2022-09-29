TRUNCATE TABLE analysis.dm_rfm_segments;
INSERT INTO analysis.dm_rfm_segments (user_id, recency, frequency, monetary_value)
SELECT 
	t1.user_id as user_id,
	t1.recency as recency,
	t2.frequency as frequency,
	t3.monetary_value as monetary_value
FROM analysis.tmp_rfm_recency t1
LEFT JOIN analysis.tmp_rfm_frequency t2 ON t1.user_id = t2.user_id
LEFT JOIN analysis.tmp_rfm_monetary_value t3 ON t1.user_id = t3.user_id;

SELECT *
FROM analysis.dm_rfm_segments
ORDER BY user_id ASC
LIMIT 10;

/*
user_id recensy frequency monetary_value
0	1	3	4
1	4	3	3
2	2	3	5
3	2	3	3
4	4	3	3
5	5	5	5
6	1	3	5
7	4	2	2
8	1	2	3
9	1	2	2
*/