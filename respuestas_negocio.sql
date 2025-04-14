/**
  Listar los usuarios que cumplan años el día de hoy cuya cantidad de ventas realizadas en enero 2020
  sea superior a 1500.
**/
select
     c.customer_id
    ,c.fist_name
    ,c.last_name
    ,count(o.order_id) sales_qty
from ecommerce.Customer c
inner join ecommerce.Item i
    on i.seller_id = c.customer_id
inner join ecommerce.Order o
    on o.item_id = i.item_id
where
    extract(month from o.order_datetime) = 1
    and extract(year from o.order_datetime) = 2020
    and date(o.order_datetime) = current_date
group by c.customer_id, c.first_name, c.last_name
having count(o.order_id) > 1500


/**
  Por cada mes del 2020, se solicita el top 5 de usuarios que más vendieron($) en la categoría Celulares.
  Se requiere el mes y año de análisis, nombre y apellido del vendedor, cantidad de ventas realizadas,
  cantidad de productos vendidos y el monto total transaccionado.
**/
with celphones_category as (
    select
        category_id
    from ecommerce.Category
    where
        lower(path) like '%celulares%'
)
,sales as (
    select
         extract(month from o.order_datetime) as month_sale
        ,extract(year from o.order_datetime) as year_sale
        ,c.fist_name as seller_firstname
        ,c.last_name as seller_lastname
        ,count(o.order_id) as sales_qty
        ,sum(o.item_qty) as item_sales_qty,
        ,sum(o.item_qty * o.item_unit_price) as sales_total_amt
    from ecommerce.Order o
    inner join ecommerce.Item i
        on o.item_id = i.item_id
    inner join ecommerce.Customer s
        on i.seller_id = s.customer_id
    inner join celphones_category cc
        on cc.category_id = i.category_id
    where
        extract(year from o.order_datetime) = 2020
    group by 1, 2, 3, 4
)
,top_five as (
    select
         month_sale
        ,year_sale
        ,seller_firstname
        ,seller_lastname
        ,sales_qty
        ,item_sales_qty,
        ,sales_total_amt
    from sales
    qualify row_number() over (partition by month_sale, year_sale order by sales_total_amt desc) <= 5
)
select
     month_sale
    ,year_sale
    ,seller_firstname
    ,seller_lastname
    ,sales_qty
    ,item_sales_qty,
    ,sales_total_amt
from top_five
order by month_sale asc, year_sale asc, sales_total_amt desc
;


/**
Se solicita poblar una nueva tabla con el precio y estado de los Ítems a fin del día.
  Tener en cuenta que debe ser reprocesable.
  Vale resaltar que en la tabla Item, vamos a tener únicamente el último estado informado por la PK definida.
  (Se puede resolver a través de StoredProcedure)
**/
CREATE OR REPLACE PROCEDURE ecommerce.populate_item_history(calendar_date DATE)
BEGIN
  DELETE FROM ecommerce.Item_History WHERE item_history_dt = calendar_date;

  INSERT INTO ecommerce.Item_History (item_history_id, item_history_dt, item_id, item_price, item_status)
  SELECT
      generate_uuid() as item_history_id
     ,calendar_date as item_history_dt
     ,item_id
     ,item_price
     ,item_status
  FROM ecommerce.Item;
END;