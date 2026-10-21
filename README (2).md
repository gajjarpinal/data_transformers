# Data Transformer

This is a small MySQL practice project built around three related tables: customers, orders, and employees. The script creates the database, loads a few sample records, and then demonstrates joins, subqueries, date functions, string functions, window functions, and `CASE` expressions.

The project is intentionally kept in one SQL file so it is easy to open in MySQL Workbench and run from top to bottom.

## What the project covers

- Creating the `datatranformer` database and its tables
- Linking customers to orders with a foreign key
- Inner, left, right, and simulated full outer joins
- Subqueries for order and salary comparisons
- Extracting, formatting, and comparing dates
- Concatenating, replacing, changing case, and trimming text
- Running totals and order ranking with window functions
- Conditional discounts and employee salary categories

## Tables and sample data

### `customers`

| customer_id | first_name | last_name | email | registration_date |
| ---: | --- | --- | --- | --- |
| 1 | John | Doe | john.doe@email.com | 2022-03-15 |
| 2 | Jane | Smith | jane.smith@email.com | 2021-11-02 |

### `orders`

The first two orders are loaded with the initial data. Orders 3 and 4 are added later in the script before the discount query.

| order_id | customer_id | order_date | total_amount |
| ---: | ---: | --- | ---: |
| 1 | 1 | 2023-07-01 | 150.50 |
| 2 | 2 | 2023-07-03 | 200.75 |
| 3 | 1 | 2023-07-05 | 1200.00 |
| 4 | 2 | 2023-07-06 | 600.00 |

### `employees`

| employee_id | first_name | last_name | department | hire_date | salary |
| ---: | --- | --- | --- | --- | ---: |
| 1 | mark | Johnson | Sales | 2020-01-15 | 50000.00 |
| 2 | Bob | Williams | Marketing | 2021-03-20 | 55000.00 |
| 3 | Alice | Brown | HR | 2022-05-10 | 54700.00 |

## How to run it

1. Open MySQL Workbench and connect to your MySQL server.
2. Open [`data_transformer.sql`](data_transformer.sql).
3. Run the complete script from the first statement to the last one.
4. The result grids will appear in the Output panel in the same order listed below.

The script uses MySQL syntax, including `DATEDIFF`, `DATE_FORMAT`, `EXTRACT`, and window functions. Re-running the file in the same server session will fail when it tries to create tables that already exist. To start over, run `DROP DATABASE IF EXISTS datatranformer;` first, then run the script again.

## Query outputs

The outputs below follow the exact order of the `SELECT` statements in the SQL file. Amounts are shown with two decimal places where MySQL returns decimal values.

### 1. Inner join: existing orders with customer information

```text
customer_id  first_name  last_name  email                registration_date  order_id  customer_id  order_date  total_amount
1            John        Doe        john.doe@email.com   2022-03-15         1         1            2023-07-01  150.50
2            Jane        Smith      jane.smith@email.com 2021-11-02         2         2            2023-07-03  200.75
```

There are two `customer_id` columns because `SELECT *` includes the column from both joined tables.

### 2. Left join: every customer and any matching order

```text
customer_id  first_name  last_name  email                registration_date  order_id  customer_id  order_date  total_amount
1            John        Doe        john.doe@email.com   2022-03-15         1         1            2023-07-01  150.50
2            Jane        Smith      jane.smith@email.com 2021-11-02         2         2            2023-07-03  200.75
```

### 3. Right join: every order and its customer

```text
customer_id  first_name  last_name  email                registration_date  order_id  customer_id  order_date  total_amount
1            John        Doe        john.doe@email.com   2022-03-15         1         1            2023-07-01  150.50
2            Jane        Smith      jane.smith@email.com 2021-11-02         2         2            2023-07-03  200.75
```

### 4. Full outer join simulation

MySQL does not provide `FULL OUTER JOIN`, so the script combines a left join and a right join with `UNION`.

```text
customer_id  first_name  last_name  email                registration_date  order_id  customer_id  order_date  total_amount
1            John        Doe        john.doe@email.com   2022-03-15         1         1            2023-07-01  150.50
2            Jane        Smith      jane.smith@email.com 2021-11-02         2         2            2023-07-03  200.75
```

### 5. Customers whose order is above their own average order amount

At this point in the script each customer has one order. Each order therefore equals that customer's average, so no row is returned.

```text
Empty set
```

### 6. Employees with a salary above the average salary

The average salary at this point is `52500.00`.

```text
employee_id  first_name  last_name  department  hire_date   salary
2            Bob         Williams   Marketing   2021-03-20  55000.00
```

### 7. Month and year extracted from order dates

```text
month  year
7      2023
7      2023
```

### 8. Days from each order date to the current date

The following values are the output when the script is run on **2026-09-30**, the date used for this README.

```text
datediff(CURDATE(),order_date)
1187
1185
```

This result is expected to change when `CURDATE()` changes. The source query is deliberately unchanged, so MySQL Workbench will show the correct number of elapsed days for the date on which it is run.

### 9. Order dates formatted as `DD-MM-YY`

```text
formatted_order_date
01-07-23
03-07-23
```

### 10. Customer full names

```text
full_name
John Doe
Jane Smith
```

### 11. First name replacement

```text
updated_first_name
Jonathan
Jane
```

### 12. Uppercase first names and lowercase last names

```text
upper_first_name  lower_last_name
JOHN              doe
JANE              smith
```

### 13. Trimmed email addresses

```text
trimmed_email
john.doe@email.com
jane.smith@email.com
```

### 14. Running total of order amounts

```text
order_id  total_amount  running_total
1         150.50        150.50
2         200.75        351.25
```

### 15. Orders ranked by total amount

```text
order_id  total_amount  order_rank
2         200.75        1
1         150.50        2
```

### 16. Discount calculated after adding orders 3 and 4

```text
order_id  total_amount  discount
1         150.50        0.00
2         200.75        0.00
3         1200.00       120.00
4         600.00        30.00
```

### 17. Employee rows displayed before salary categorization

```text
employee_id  first_name  last_name  department  hire_date   salary
1            mark        Johnson    Sales       2020-01-15  50000.00
2            Bob         Williams   Marketing   2021-03-20  55000.00
3            Alice       Brown      HR          2022-05-10  54700.00
```

### 18. Employee salary categories

The average salary after Alice is added is approximately `53233.33`.

```text
employee_id  salary    salary_category
1            50000.00  medium
2            55000.00  high
3            54700.00  low
```

## Video

This video explains the project and the SQL concepts used in it:

[Watch the Data Transformer walkthrough](https://youtu.be/2kfHgGa4piA)

## Notes

- The database name is `datatranformer`, matching the name used in the SQL file.
- The full outer join is implemented with `LEFT JOIN ... UNION ... RIGHT JOIN` because that is the MySQL-compatible approach used by the script.
- The README records the date-sensitive output for 2026-09-30. All other outputs are based directly on the inserted sample data.