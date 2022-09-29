| Таблицы             | Объект                      | Инструмент      | Для чего используется |
| ------------------- | --------------------------- | --------------- | --------------------- |
| production.orderitems | id int NOT NULL PRIMARY KEY | Первичный ключ  | Служит для идентификации строк в таблице |
| production.orderitems |CONSTRAINT orderitems_order_id_product_id_key UNIQUE (order_id, product_id) | Составной ключ  |            Обеспечивает уникальную связку товар+заказ - один и тот же товар может быть в заказе только 1 раз|
| production.orderitems | orderitems_order_id_fkey FOREIGN KEY (order_id)REFERENCES production.orders (order_id) | Внешний ключ  |            Обеспечивает присутствие в таблице только тех заказов, которые находятся в таблице  заказов|
| production.orderitems | CONSTRAINT orderitems_product_id_fkey FOREIGN KEY (product_id) REFERENCES production.products (id) |            Внешний ключ  |Обеспечивает нахождение в таблице только тех продуктов, идентификаторы которых находятся в             таблице продуктов |
| production.orderitems | orderitems_price_check CHECK (price >= 0::numeric) | Проверка значений  | Обеспецивает неотрицательные цены |
| production.orderitems | orderitems_check CHECK (discount >= 0::numeric AND discount <= price) | Проверка значений  | Служит для ограничения скидки - неотрицательная и меньше цены |
| production.orderitems | orderitems_quantity_check CHECK (quantity > 0) | Проверка значений | Служит для ограничения количества товаров в заказе строго положительным|
| production.orders | bonus_payment numeric(19,5) NOT NULL DEFAULT 0,
    payment numeric(19,5) NOT NULL DEFAULT 0,
    cost numeric(19,5) NOT NULL DEFAULT 0,
    bonus_grant numeric(19,5) NOT NULL DEFAULT 0 | Значения по-умолчанию  | Если значение поля не определено, оно заменяется на 0 |
| production.orders |order_id integer NOT NULL PRIMARY KEY | Первичный ключ  | Обеспечивает уникальность идентификаторов заказов |
| production.orders |orders_check CHECK (cost = (payment + bonus_payment)) | Проверка значений  | Обеспечивает выполнимость условия стоимость = оплата+бонусная оплата |
| production.orderstatuses |id integer NOT NULL PRIMARY KEY | Первичный ключ  | Обеспечивает уникальность идентификаторов статуса заказа в справочнике |
| production.products | id integer NOT NULL PRIMARY KEY | Первичный ключ  | Обеспечивает уникальность идентификаторов продукта в справочнике |
| production.orderstatuses |roducts_price_check CHECK (price >= 0::numeric)| Проверка значения  | Обеспечивает неотрицательность цены продукта в справочнике |
| production.users |id integer NOT NULL PRIMARY KEY | Первичный ключ  | Обеспечивает уникальность идентификаторов пользователей в справочнике |