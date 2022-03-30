-- roles table
create table roles(
	roles_id serial primary key,
	role_name varchar(10)
)
insert into roles (role_name) values ('Buyer'); --role_id=1
insert into roles (role_name) values ('Seller'); --role_id=2
insert into roles (role_name) values ('Admin'); -- role_id=3
select * from roles;

-- users table
create table users(
	user_id serial primary key,
	user_name varchar(50),
	age int,
	address varchar(255),
	role_id int references roles(roles_id)
);

insert into users (user_name, age, gender,address, role_id)
values
('User1',42,'Delhi',1),
('User2',38,'Pune',1),
('User3',26,'Mumbai',2),
('User4',22,'Noida',2),
('User5',19,'Hyderabad',1),
('User6',34,'Surat',3),
('User7',48,'Jaipur',1),
('User8',50,'Bangalore',3);

select * from users;

-- products table
create table products(
	product_id serial primary key,
	product_name varchar(100),
	price int,
	quantity int
);
insert into products(product_name, price,quantity)
values
('Product1', 100,50),
('Product2', 200,60),
('Product3', 300,40),
('Product4', 700,50),
('Product5', 1500,10);
update products set quantity= 50 where product_name='Product_4'
select * from products;

--orders table
create table orders(
	order_id serial primary key,
	buyer_id int references users(user_id),
	seller_id int references users(user_id),
	product_id int references products(product_id),
	order_value int,
	order_date date
);


insert into orders(buyer_id, seller_id,product_id,order_value,order_date)
values
(1,3,1,100,now()),
(5,3,3,200,now()),
(3,4,4,300,now()),
(2,4,2,700,now()),
(7,3,5,1500,now());
insert into orders(buyer_id, seller_id, product_id, order_value, order_date)
values (1,4,4,700,now());

select * from orders;

-- fuction to increase the value of order in case of addition of same product
-- along with updation of quantity in the products table
create or replace function fn_order_update()
returns trigger
language PLPGSQL
as

$$
	declare prev_value int;
	begin
	
	-- prev_value=order_value;
	update orders set order_value= order_value+(select price from products where product_id=new.product_id)
	where product_id=new.product_id;
	--delete from orders where product_id=new.product_id and (now()- orders.order_date> interval '2 minutes');
	update products set quantity=quantity-1 where product_id= new.product_id;
	return NEW;
	end;
$$


create trigger on_addition_of_order
before insert
on orders
for each row
	execute procedure fn_order_update();

-- function to delete the previous value
create or replace function fn_delete_entry()
returns trigger
language plpgsql
as
$$
	begin
		delete from orders where product_id=new.product_id and buyer_id=new.buyer_id 
		and order_value< (select max(order_value) from orders where product_id=new.product_id);
		return new;
	end;
$$

create trigger after_addition
after insert
on orders
for each row execute procedure
	fn_delete_entry();

-- view to check the invoice	
create or replace view invoice
as
select 
o.order_id,
users.user_name,
sn.seller_name,
products.product_name,
o.order_value,
o.order_date
from orders as o
inner join
users
on o.buyer_id=users.user_id
inner join 
products
on o.product_id= products.product_id
inner join 
seller_names as sn
on o.seller_id=sn.user_id

-- view to get the seller_names from the users table
create or replace view seller_names as 
select user_id,user_name as seller_name from users where user_id in (3,4);

select * from invoice; -- generating the invoice