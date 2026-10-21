create database datatranformer;

use datatranformer;

create table customers(
    customer_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    registration_date date
);

create table orders(
    order_id int primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10, 2),
    foreign key (customer_id) references customers(customer_id)
);

create table employees(
    employee_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    department varchar(50),
    hire_date date,
    salary decimal(10, 2)
);


insert into customers values
(1, 'John', 'Doe', 'john.doe@email.com', '2022-03-15'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '2021-11-02');

insert into orders values
(1, 1, '2023-07-01', 150.50),
(2, 2, '2023-07-03', 200.75);

insert into employees values
(1, 'mark', 'Johnson', 'Sales', '2020-01-15', 50000.00),
(2, 'Bob', 'Williams', 'Marketing', '2021-03-20', 55000.00);

# Inner join : Retrieve all orders and customer information where order is existing
select * from customers as cs 
join orders as od
on cs.customer_id = od.customer_id;

# Left join : Retrieve all customers and their corresponding orders(if any)
select * from customers as cs
left join orders as od
on cs.customer_id = od.customer_id;

# Right join : Retrieve all orders and their corresponding customers(if any)
select * from customers as cs
right join orders as od
on cs.customer_id = od.customer_id;

# full outer join : Retrieve all customers and orders, including those without matches
SELECT * FROM customers AS cs 
LEFT JOIN orders AS od ON cs.customer_id = od.customer_id
UNION
SELECT * FROM customers AS cs 
RIGHT JOIN orders AS od ON cs.customer_id = od.customer_id;

#subquery : Retrieve all customers who have placed orders which more than avg order amount
select * from customers as cs
join orders as od
on cs.customer_id = od.customer_id
where od.total_amount>(select avg(total_amount)  from orders where cs.customer_id = od.customer_id );


#subquery to find employees with salary greater than average salary
select * from employees as emp
where emp.salary > (select avg(salary) from employees);

# extract month and year from orderdate
select extract( month from order_date) as month,
	   extract(year from order_date) as year from orders; 

# caculate the difference between current date and order date   
select datediff(CURDATE(),order_date) from orders;

# formate the order date to display in 'DD-MM-YYYY' format
select date_format(order_date, '%d-%m-%y') as formatted_order_date from orders;

# concatenate first name and last name of customers to create full name
select concat(first_name,' ', last_name) as full_name from customers;

#replace the part of sting (eg replace 'john' with 'jonathan') 
select replace(first_name, 'John', 'Jonathan') as updated_first_name from customers;

#convert  firstname to upper case and last name  to lower case 
select upper(first_name) as upper_first_name, lower(last_name) as lower_last_name from customers;

#trim extra spaces from email addresses
select trim(email) as trimmed_email from customers;

#calculate the running total of order amounts for each order
select order_id, total_amount,
       sum(total_amount) over (order by order_date) as running_total
from orders;

#rank orders based on totalamount using RANK() function 
select order_id, total_amount,
       rank() over (order by total_amount desc) as order_rank
from orders;

#Assign a discount based on totalamount in orders (e.g.,> 1000:10% discount, >500:5% discount)
insert into orders values
(3, 1, '2023-07-05', 1200.00),
(4, 2, '2023-07-06', 600.00);
select order_id, total_amount,
       case 
           when total_amount > 1000 then total_amount * 0.10
           when total_amount > 500 then total_amount * 0.05
           else 0
       end as discount
from orders;

#categorize employees salaries as 'high', 'medium', or 'low' based on salary ranges
select * from employees;
insert into employees values
(3, 'Alice', 'Brown', 'HR', '2022-05-10', 54700.00);

select employee_id, salary,
       case 
           when salary > 54800 then 'high'
           when salary < (select avg(salary) from employees) and salary < 54800  then 'medium'
           else 'low'
       end as salary_category
from employees;
    

