create database site;
use site;

create table CLIENTS(
id int primary key auto_increment,
nome varchar(50) not null,
email varchar(50) not null
);
create table PRODUCTS(
id int primary key auto_increment,
nome varchar(50) not null,
price decimal(6, 2) not null
);
create table ORDERS(
id int primary key auto_increment,
client_id int,
foreign key (client_id) references CLIENTS(id), 
order_date date not null,
total decimal(5,2) not null
);
create table ORDER_ITEMS(
order_id int,
foreign key (order_id) references ORDERS(id),
product_id int,
foreign key(product_id) references PRODUCTS(id),
quantity int not null,
price decimal(6,2) not null
);

insert into CLIENTS (nome,email) values
("david", "dada@gmail.com"),
("marata", "mara@gmail.com"),
("bruna", "bubu@gmail.com"),
 ("lucas", "lulu@gmail.com");

insert into PRODUCTS (nome,price) values
("ventilador", 100.00),
("TV", 2000.00),
("desodorante", 1700.00),
("colchão", 1000.00);

insert into ORDERS (order_date,total, client_id) values
("2014-05-13",5,3),
("2007-08-15", 5, 1),
("2009-07-13", 20,3),
("2013-07-12", 10,4),
("2018-09-19", 9 ,2);

insert into ORDER_ITEMS(quantity, price,order_id, product_id) values
(10, 2000.00, 1, 1),
(60, 7000.00,4, 4),
(10, 2000.00, 1, 1),
(20, 3000.00, 2, 2),
(30, 4000.00, 3, 3),
(60, 7000.00,4, 4);

UPDATE PRODUCTS
SET price = 200.00
WHERE id = 1 ;

update ORDER_ITEMS
set price = 200.00
where product_id = 1;

delete from CLIENTS where id = 4;
delete from ORDER_ITEMS where order_id = 3;
delete from ORDERS where id = 3;

alter table CLIENTS add column birthdate date;
UPDATE `clients` SET `birthdate` = '2007-08-15' WHERE (`id` = '1');


select ORDERS.id, CLIENTS.nome as nome_do_cliente, PRODUCTS.nome  as nome_do_produtoa
from ORDERS
inner join CLIENTS on CLIENTS.id = ORDERS.client_id
inner join PRODUCTS ON  PRODUCTS.id = CLIENTS.id;

select CLIENTS.nome, ORDERS.id 
from CLIENTS
left join ORDERS on CLIENTS.id  = ORDERS.client_id ;

select PRODUCTS.nome, ORDERS.id
from ORDERS
inner join order_items on order_items.order_id = ORDERS.id
right join PRODUCTS on order_items.product_id = PRODUCTS.id;

select orders.id,clients.nome,  products.nome
from orders
inner join ORDER_ITEMS on ORDER_ITEMS.order_id = orders.id
inner join clients on clients.id = orders.client_id;


select SUM(total) as total_sell, SUM(quantity) as sells_quantity
from ORDERS
inner join ORDER_ITEMS  on ORDER_ITEMS.product_id = orders.id
order by total_sell DESC;

select clients.id, nome as clients_name, count(total) as total_sell
from CLIENTS
inner join ORDERS on ORDERS.client_id = CLIENTS.id
group by CLIENTS.id
order by total_sell DESC;

select id, nome as products_name, count(quantity) as total_quantity
from PRODUCTS
left join ORDER_ITEMS on ORDER_ITEMS.product_id= products.id 
group by PRODUCTS.id
order by total_quantity DESC;

select nome as clients_name, sum(price) as spend_value
from CLIENTS
inner join ORDERS on ORDERS.client_id = CLIENTS.id
inner join ORDER_ITEMS on ORDER_ITEMS.order_id = ORDERS.id
group by CLIENTS.id
order by spend_value DESC;

-- Faça uma consulta para listar os 3 produtos mais vendidos (em quantidade) e o total de vendas de cada um.

select nome as products_name, sum(quantity)as quantity_of_products, sum(total) as total_products
from PRODUCTS
inner join ORDER_ITEMS on ORDER_ITEMS.product_id = PRODUCTS.id
inner join ORDERS on ORDERS.id = ORDER_ITEMS.order_id
group by PRODUCTS.id
order by products_name DESC;

-- Faça uma consulta para listar os 3 clientes que mais gastaram e o total gasto por cada um.

select nome as client_name, max(price) as top_values
from CLIENTS
inner join ORDERS on ORDERS.client_id = clients.id
inner join ORDER_ITEMS on ORDER_ITEMS.order_id = ORDERS.id
group by clients.id
order by top_values DESC
limit 3;

-- Faça uma consulta para listar a média de quantidade de produtos por pedido para cada cliente.

select CLIENTS.id as client_id,clients.nome as client_name, products.nome as product_name, avg(quantity) as média_de_item
from CLIENTS
inner join ORDERS on ORDERS.client_id = CLIENTS.id
inner join order_items on order_items.order_id = ORDERS.id
inner join PRODUCTS on  order_items.product_id = PRODUCTS.id 
group by client_id, client_name, product_name
order by média_de_item;

-- Faça uma consulta para listar os produtos que nunca foram vendidos

-- faça uma consulta para listar os clientes com o maior valor médio por pedido.

select clients.nome as clients_name, AVG(price) as price_media
from clients
inner join ORDERS on orders.client_id = clients.id
inner join ORDER_ITEMS on ORDER_ITEMS.order_id = orders.id
group by clients_name
order by price_media desc;

-- Faça uma consulta para listar os produtos que nunca foram vendidos.

	select products.nome
	from products
	left join ORDER_ITEMS on ORDER_ITEMS.product_id = PRODUCTS.id
    where ORDER_ITEMS.order_id is null 
    group by products.nome
    order by products.nome
