# Витрина RFM

## 1.1. Выясните требования к целевой витрине.

Постановка задачи выглядит достаточно абстрактно - постройте витрину. Первым делом вам необходимо выяснить у заказчика детали. Запросите недостающую информацию у заказчика в чате.

Зафиксируйте выясненные требования. Составьте документацию готовящейся витрины на основе заданных вами вопросов, добавив все необходимые детали.

-----------

{Впишите сюда ваш ответ}
Постановка задачи

Что сделать:
    Необходимо создать витрину данных для RFM-классификации пользователей приложения.
    Назвать витрину: dm_rfm_segments
    Расположение витрины: база данных de; схема - analysis
    Дополнительная информация: успешно выполненным заказом считается заказ со статусом Closed
За какой период: 
    Данные с начала 2022 года
Обновление данных:
    Не требуется

Необходимая структура:
    -user_id - идентификатор пользователя
    -recency - число от 1 до 5; Фактор Recency измеряется по последнему заказу. Распределите клиентов по шкале от одного до пяти, где значение 1 получат те, кто либо вообще не делал заказов, либо делал их очень давно, а 5 — те, кто заказывал относительно недавно.
    -frequency - число от 1 до 5; Фактор Frequency оценивается по количеству заказов. Распределите клиентов по шкале от одного до пяти, где значение 1 получат клиенты с наименьшим количеством заказов, а 5 — с наибольшим.
    -monetary_value - число от 1 до 5; Фактор Monetary Value оценивается по потраченной сумме. Распределите клиентов по шкале от одного до пяти, где значение 1 получат клиенты с наименьшей суммой, а 5 — с наибольшей.




## 1.2. Изучите структуру исходных данных.

Полключитесь к базе данных и изучите структуру таблиц.

Если появились вопросы по устройству источника, задайте их в чате.

Зафиксируйте, какие поля вы будете использовать для расчета витрины.

-----------

{Впишите сюда ваш ответ}
    -user_id - production.users.id - идентификатор пользователя для всех таблиц
    -recency - для расчета будет использовано поле production.orders.order_ts - дата заказа
    -frequency - для расчета будет использовано поле production.orders.order_id - уникальный идентификатор заказа
    -monetary_value - для расчета будет использовано поле production.orders.cost - сумма заказа
    -для фильтрации заказов со статусом Closed будут использоваться: production.orders.status FK production.orderstatuses.id и production.orderstatuses.key



## 1.3. Проанализируйте качество данных

Изучите качество входных данных. Опишите, насколько качественные данные хранятся в источнике. Так же укажите, какие инструменты обеспечения качества данных были использованы в таблицах в схеме production.

-----------

{Впишите сюда ваш ответ}
Качество данных источника:
    -в источнике достаточно полей для реализации задачи
    -типы данных полей корректны и соответствуют данным
    -практически везде присутствуют необходимые ограничения
    -в таблице production.orders  отсутствую внешние ключи для полей user_id, status. Но, при этом, отсутствуют записи с идентификатором пользователя, отсутствующем в production.users; отутствуют записи со статусом, отсутствующем в справочнике статусов production.orderstatuses

Инструменты обеспечения качества данных:
    -Определены первичные ключи
        Например: CONSTRAINT orderitems_pkey PRIMARY KEY (id)
    -Для всех полей определены типы данных, строковые типы данных для хранения не текстовой информации не используются
        Например: price numeric(19,5) NOT NULL DEFAULT 0
    -В полях, обязательных для заполнения, установлено ограничений NOT NULL
        Например: price numeric(19,5) NOT NULL DEFAULT 0
    -Установлены значения полей по-умолчанию
        Например: price numeric(19,5) NOT NULL DEFAULT 0
    -Установлены ограничения значений в виде внешних ключей
        Например: CONSTRAINT orderitems_product_id_fkey FOREIGN KEY (product_id)
        REFERENCES production.products (id) MATCH SIMPLE
    -Установлены ограничения значений полей
        Например: CONSTRAINT products_price_check CHECK (price >= 0::numeric)
    -Установлены ограничения на уникальные значения полей(составные ключи таблиц)
        Наример: CONSTRAINT orderitems_order_id_product_id_key UNIQUE (order_id, product_id),


## 1.4. Подготовьте витрину данных

Теперь, когда требования понятны, а исходные данные изучены, можно приступить к реализации.

### 1.4.1. Сделайте VIEW для таблиц из базы production.**

Вас просят при расчете витрины обращаться только к объектам из схемы analysis. Чтобы не дублировать данные (данные находятся в этой же базе), вы решаете сделать view. Таким образом, View будут находиться в схеме analysis и вычитывать данные из схемы production. 

Напишите SQL-запросы для создания пяти VIEW (по одному на каждую таблицу) и выполните их. Для проверки предоставьте код создания VIEW.

```SQL
--Впишите сюда ваш ответ
CREATE OR REPLACE VIEW analysis.v_users AS
SELECT id, name, login
	FROM production.users;
CREATE OR REPLACE VIEW analysis.v_orders AS
SELECT order_id, order_ts, user_id, bonus_payment, payment, cost, bonus_grant, status
	FROM production.orders;
CREATE OR REPLACE VIEW analysis.v_orderitems AS
SELECT id, product_id, order_id, name, price, discount, quantity
	FROM production.orderitems;
CREATE OR REPLACE VIEW analysis.v_products AS
SELECT id, name, price
	FROM production.products;
CREATE OR REPLACE VIEW analysis.v_orderstatuses AS
SELECT id, key
	FROM production.orderstatuses;


```

### 1.4.2. Напишите DDL-запрос для создания витрины.**

Далее вам необходимо создать витрину. Напишите CREATE TABLE запрос и выполните его на предоставленной базе данных в схеме analysis.

```SQL
--Впишите сюда ваш ответ
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

```

### 1.4.3. Напишите SQL запрос для заполнения витрины

Наконец, реализуйте расчет витрины на языке SQL и заполните таблицу, созданную в предыдущем пункте.

Для решения предоставьте код запроса.

```SQL
--Впишите сюда ваш ответ
DROP TABLE IF EXISTS analysis.tmp_rfm_recency;
CREATE TABLE analysis.tmp_rfm_recency (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);
INSERT INTO analysis.tmp_rfm_recency
WITH closed_orders as (
	SELECT 
		t1.order_ts as order_ts,
		t1.user_id as user_id	
		FROM analysis.v_orders t1
		LEFT JOIN analysis.v_orderstatuses t2 ON t1.status = t2.id
	WHERE
		t2.key = 'Closed'
	AND
		t1.order_ts BETWEEN '2022-01-01 00:00:01' AND '2022-12-31 23:59:59'
		),
all_users as (
	SELECT
		t1.id as user_id,
		COALESCE(t2.order_ts, '2021-12-31 23:59:59') as order_ts
	FROM 
		production.users t1
	LEFT JOIN closed_orders t2 ON t1.id = t2.user_id
),
user_in_segment as(
	SELECT 
		CAST(COUNT(DISTINCT user_id) as float) / 5  as usr_count
	FROM all_users
),
last_user_order as (
	SELECT 
		user_id,
		MAX(order_ts) as order_ts
		FROM all_users
	GROUP BY
		user_id
)
SELECT
	t.user_id as user_id,
	CASE 
		WHEN t.row_num <= (SELECT usr_count FROM user_in_segment) THEN 1
		WHEN t.row_num > (SELECT usr_count FROM user_in_segment) AND
				t.row_num <= (SELECT usr_count*2 FROM user_in_segment) THEN 2
		WHEN t.row_num > (SELECT usr_count*2 FROM user_in_segment) AND
				t.row_num <= (SELECT usr_count*3 FROM user_in_segment) THEN 3
		WHEN t.row_num > (SELECT usr_count*3 FROM user_in_segment) AND
				t.row_num <= (SELECT usr_count*4 FROM user_in_segment) THEN 4
		WHEN t.row_num > (SELECT usr_count*4 FROM user_in_segment) THEN 5
	END as recency
	FROM (              
		SELECT 
			user_id,
			ROW_NUMBER() OVER(ORDER BY order_ts ASC) as row_num
		FROM last_user_order) t;
DROP TABLE IF EXISTS analysis.tmp_rfm_frequency;
CREATE TABLE analysis.tmp_rfm_frequency (
 user_id INT NOT NULL PRIMARY KEY,
 frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5)
);
INSERT INTO analysis.tmp_rfm_frequency
WITH closed_orders as (
	SELECT 
		t1.order_id as order_id,
		t1.user_id as user_id	
		FROM analysis.v_orders t1
		LEFT JOIN analysis.v_orderstatuses t2 ON t1.status = t2.id
	WHERE
		t2.key = 'Closed'
	AND
		t1.order_ts BETWEEN '2022-01-01 00:00:01' AND '2022-12-31 23:59:59'
		),
all_users as (
	SELECT
		t1.id as user_id,
		COALESCE(t2.order_id, -1) as order_id
	FROM 
		production.users t1
	LEFT JOIN closed_orders t2 ON t1.id = t2.user_id
),
user_in_segment as(
	SELECT 
		CAST(COUNT(DISTINCT user_id) as float) / 5  as usr_count
	FROM all_users
),
count_user_order as (
	SELECT 
		user_id,
		COUNT(order_id) as order_count
	FROM all_users
	GROUP BY 
		user_id
)
SELECT
	t.user_id as user_id,
	CASE 
		WHEN t.row_num <= (SELECT usr_count FROM user_in_segment) THEN 1
		WHEN t.row_num > (SELECT usr_count FROM user_in_segment) AND
				t.row_num <= (SELECT usr_count*2 FROM user_in_segment) THEN 2
		WHEN t.row_num > (SELECT usr_count*2 FROM user_in_segment) AND
				t.row_num <= (SELECT usr_count*3 FROM user_in_segment) THEN 3
		WHEN t.row_num > (SELECT usr_count*3 FROM user_in_segment) AND
				t.row_num <= (SELECT usr_count*4 FROM user_in_segment) THEN 4
		WHEN t.row_num > (SELECT usr_count*4 FROM user_in_segment) THEN 5
	END as frequency
	FROM (              
		SELECT 
			user_id,
			ROW_NUMBER() OVER(ORDER BY order_count ASC) as row_num
		FROM count_user_order) t;
DROP TABLE IF EXISTS analysis.tmp_rfm_monetary_value;
CREATE TABLE analysis.tmp_rfm_monetary_value (
 user_id INT NOT NULL PRIMARY KEY,
 monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);
INSERT INTO analysis.tmp_rfm_monetary_value
WITH closed_orders as (
	SELECT 
		t1.cost as order_cost,
		t1.user_id as user_id	
		FROM analysis.v_orders t1
		LEFT JOIN analysis.v_orderstatuses t2 ON t1.status = t2.id
	WHERE
		t2.key = 'Closed'
	AND
		t1.order_ts BETWEEN '2022-01-01 00:00:01' AND '2022-12-31 23:59:59'
		),
all_users as (
	SELECT
		t1.id as user_id,
		COALESCE(t2.order_cost, 0) as order_cost
	FROM 
		production.users t1
	LEFT JOIN closed_orders t2 ON t1.id = t2.user_id
),
user_in_segment as(
	SELECT 
		CAST(COUNT(DISTINCT user_id) as float) / 5  as usr_count
	FROM all_users
),
sum_user_order as (
	SELECT 
		user_id,
		SUM(order_cost) as sum_orders
	FROM all_users
	GROUP BY 
		user_id
)
SELECT
	t.user_id as user_id,
	CASE 
		WHEN t.row_num <= (SELECT usr_count FROM user_in_segment) THEN 1
		WHEN t.row_num > (SELECT usr_count FROM user_in_segment) AND
				t.row_num <= (SELECT usr_count*2 FROM user_in_segment) THEN 2
		WHEN t.row_num > (SELECT usr_count*2 FROM user_in_segment) AND
				t.row_num <= (SELECT usr_count*3 FROM user_in_segment) THEN 3
		WHEN t.row_num > (SELECT usr_count*3 FROM user_in_segment) AND
				t.row_num <= (SELECT usr_count*4 FROM user_in_segment) THEN 4
		WHEN t.row_num > (SELECT usr_count*4 FROM user_in_segment) THEN 5
	END as monetary_value
	FROM (              
		SELECT 
			user_id,
			ROW_NUMBER() OVER(ORDER BY sum_orders ASC) as row_num
		FROM sum_user_order) t;	
		
```



