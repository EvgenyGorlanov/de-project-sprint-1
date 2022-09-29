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