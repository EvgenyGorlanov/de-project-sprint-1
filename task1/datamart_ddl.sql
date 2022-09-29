DROP TABLE IF EXISTS analysis.dm_rfm_segments;
CREATE TABLE IF NOT EXISTS analysis.dm_rfm_segments (
	user_id integer NOT NULL,
	recency smallint NOT NULL,
	frequency smallint NOT NULL,
	monetary_value smallint NOT NULL,	
	PRIMARY KEY(user_id),
	CONSTRAINT dm_rfm_segments_recency_check CHECK (recency > 0 AND recency < 6),
	CONSTRAINT dm_rfm_segments_frequency_check CHECK (frequency > 0 AND frequency < 6),
	CONSTRAINT dm_rfm_segments_monetary_value_check CHECK (monetary_value > 0 AND monetary_value < 6)
);