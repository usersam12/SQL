-- ===================================
-- Project: Danny's Diner
-- Author: Sam Zivin
-- Date: 2026-02
-- Description: Analyzes customer sales and new member rewards system.
-- ====================================

-- 1. What is the total amount each customer spent at the restaurant?
SELECT s.customer_id, SUM(m.price) AS total_amount
    FROM sales as s
LEFT JOIN menu as m
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_amount;

-- 2. How many days has each customer visited the restaurant?

SELECT customer_id, COUNT (DISTINCT order_date) AS days_visited
FROM sales
GROUP BY customer_id;
-- 3. What was the first item from the menu purchased by each customer?

SELECT customer_id, order_date, product_name
FROM (
    SELECT 
        s.customer_id, 
        s.order_date, 
        m.product_name,
        ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ASC) as rn
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
) AS ranked_sales
WHERE rn = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
    m.product_name, 
    COUNT(s.product_id) AS total_purchases
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_purchases DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
SELECT 
    customer_id, 
    product_name, 
    order_count
FROM (
    SELECT 
        s.customer_id, 
        m.product_name, 
        COUNT(s.product_id) AS order_count,
        RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(s.product_id) DESC) as rn
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
) AS ranked_sales
WHERE rn = 1;

-- 6. Which item was purchased first by the customer after they became a member?
SELECT customer_id, order_date, product_name
FROM (
    SELECT 
        s.customer_id, 
        s.order_date, 
        m.product_name,
  mem.join_date,
        ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ASC) as rn
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
  JOIN members mem ON s.customer_id = mem.customer_id
  WHERE s.order_date >= mem.join_date
) AS ranked_sales
WHERE rn = 1
;

-- 7. Which item was purchased just before the customer became a member?
SELECT customer_id, order_date, product_name
FROM (
    SELECT 
        s.customer_id, 
        s.order_date, 
        m.product_name,
  mem.join_date,
        ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) as rn
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
  JOIN members mem ON s.customer_id = mem.customer_id
  WHERE s.order_date < mem.join_date
) AS ranked_sales
WHERE rn = 1
;

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT 
    mem.customer_id, 
    COUNT(s.product_id) AS total_items, 
    COALESCE(SUM(m.price), 0) AS total_spent
FROM members AS mem
LEFT JOIN sales AS s 
    ON mem.customer_id = s.customer_id 
    AND s.order_date < mem.join_date
LEFT JOIN menu AS m 
    ON s.product_id = m.product_id
GROUP BY mem.customer_id
ORDER BY mem.customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT 
    s.customer_id,
    SUM(
        CASE 
            WHEN m.product_name = 'sushi' THEN m.price * 10 * 2 
            ELSE m.price * 10 
        END
    ) AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_points DESC;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT 
    s.customer_id,
    SUM(
        CASE 
            WHEN m.product_name = 'sushi'
      OR s.order_date BETWEEN mem.join_date AND (join_date + INTERVAL '6 days')  THEN m.price * 10 * 2
            ELSE m.price * 10 
        END
    ) AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
      JOIN members mem ON s.customer_id = mem.customer_id
      WHERE s.order_date <= '2021-01-31'
GROUP BY s.customer_id
ORDER BY total_points DESC;
