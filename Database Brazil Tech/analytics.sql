USE brazil_tech;

-- PRODUTOS MAIS VENDIDOS NO QUARTO TRIMESTRE DE 2025

SELECT 
	p.name AS Products,
    QUARTER(o.order_date) AS Quarter,
    YEAR(o.order_date) AS Year,
    COUNT(*) total_orders
FROM product p
INNER JOIN order_items USING (product_id)
INNER JOIN orders o USING (order_id)
WHERE YEAR(o.order_date) = 2025 AND QUARTER(o.order_date)=4
GROUP BY Products, Year, Quarter;

-- TICKET MÉDIO POR CLIENTE

SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS Customer,
    FORMAT(SUM(oi.quantity * oi.unit_price)/COUNT(DISTINCT o.order_id), 2) AS TicketM
FROM customer c 
INNER JOIN orders o USING (customer_id)
INNER JOIN order_items oi USING (order_id)
GROUP BY Customer
ORDER BY SUM(oi.quantity * oi.unit_price)/COUNT(DISTINCT o.order_id) DESC;

-- TOP CLIENTES 

SELECT 
	CONCAT_WS(' ', c.first_name, c.last_name) AS Customer,
    FORMAT(SUM(oi.subtotal),2) AS Amount
FROM customer c 
INNER JOIN orders o USING (customer_id)
INNER JOIN order_items oi USING (order_id)
WHERE o.status_orders NOT IN ('cancelled', 'processing')
GROUP BY Customer
ORDER BY SUM(oi.subtotal) DESC;

-- SAZONALIDADE DAS VENDAS

SELECT 
	MONTHNAME(o.order_date) AS MONTH,
    FORMAT(SUM(oi.subtotal),2) AS SALES
FROM orders o 
LEFT JOIN order_items oi USING (order_id)
WHERE o.status_orders <> 'cancelled' AND YEAR(o.order_date) = 2025
GROUP BY MONTH 
ORDER BY SUM(oi.subtotal) DESC;

--  clientes da Brazil Tech que tiveram um ticket médio acima da média geral da empresa em 2025 (considerando apenas pedidos não cancelados)

SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS CUSTOMER,
	ROUND(SUM(oi.quantity*oi.unit_price)/COUNT(DISTINCT o.order_id), 2) AS TICKET_MEDIUM_CUSTOMER
FROM customer c
INNER JOIN orders o USING (customer_id)
INNER JOIN order_items oi USING (order_id)
WHERE o.status_orders <> 'cancelled'
	AND YEAR(o.order_date)=2025
GROUP BY CUSTOMER
HAVING  TICKET_MEDIUM_CUSTOMER > (
	SELECT 
		ROUND(SUM(oi2.quantity*oi2.unit_price)/COUNT(DISTINCT o2.order_id),2) AS TICKET_MEDIUM_ALL
	FROM orders o2
    INNER JOIN order_items oi2 USING (order_id)
    WHERE o2.status_orders <> 'cancelled'
		AND YEAR(o2.order_date) = 2025
);
