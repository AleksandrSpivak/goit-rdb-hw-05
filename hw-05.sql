/* 1. Напишіть SQL запит, який буде відображати таблицю order_details та поле customer_id з таблиці orders 
відповідно для кожного поля запису з таблиці order_details.
Це має бути зроблено за допомогою вкладеного запиту в операторі SELECT.
*/

use hw_03;

select order_details.*, (
select customer_id from orders where orders.id = order_details.order_id
) as customer_id
from order_details;


/* 2. Напишіть SQL запит, який буде відображати таблицю order_details. 
Відфільтруйте результати так, щоб відповідний запис із таблиці orders виконував умову shipper_id=3.
Це має бути зроблено за допомогою вкладеного запиту в операторі WHERE.
*/

select * from order_details
where order_details.order_id in (select orders.id from orders where shipper_id = 3);


/* 3. Напишіть SQL запит, вкладений в операторі FROM, який буде обирати рядки з умовою quantity>10 
з таблиці order_details. Для отриманих даних знайдіть середнє значення поля quantity — групувати слід за order_id.
*/

select order_id, avg(quantity) from
(select * from order_details where order_details.quantity > 10) as tmp
group by order_id;


/* 4. Розв’яжіть завдання 3, використовуючи оператор WITH для створення тимчасової таблиці temp. 
Якщо ваша версія MySQL більш рання, ніж 8.0, створіть цей запит за аналогією до того, як це зроблено в конспекті.
*/

with temp_table as (select * from order_details where order_details.quantity > 10)
select order_id, avg(quantity) from temp_table
group by order_id;


/* 5. Створіть функцію з двома параметрами, яка буде ділити перший параметр на другий. 
Обидва параметри та значення, що повертається, повинні мати тип FLOAT.
Використайте конструкцію DROP FUNCTION IF EXISTS. Застосуйте функцію до атрибута quantity таблиці order_details . 
Другим параметром може бути довільне число на ваш розсуд.
*/

drop function if exists division;

delimiter //
create function division (num_1 float, num_2 float)
returns float
no sql
deterministic

begin
	declare result float;
    set result = num_1 / num_2;
    return result;
end//

delimiter ;

select quantity, division(quantity, 2) from order_details;
