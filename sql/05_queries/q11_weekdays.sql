-- | 11 | Orders by day of week | custom ORDER BY with CASE |

-- Note: 0 = Monday, 1 = Tuesday, 2 = Wednesday, 3 = Thursday, 4 = Friday, 
-- 5 = Saturday, 6 = Sunday.

SELECT CASE 
	WHEN WEEKDAY(order_purchase_timestamp) = 0 THEN 'Monday'
    WHEN WEEKDAY(order_purchase_timestamp) = 1 THEN 'Tuesday'
    WHEN WEEKDAY(order_purchase_timestamp) = 2 THEN 'Wednesday'
    WHEN WEEKDAY(order_purchase_timestamp) = 3 THEN 'Thursday'
    WHEN WEEKDAY(order_purchase_timestamp) = 4 THEN 'Friday'
    WHEN WEEKDAY(order_purchase_timestamp) = 5 THEN 'Saturday'
    ELSE 'Sunday'
END AS week_names,
COUNT(order_id)
FROM orders
GROUP BY week_names
ORDER BY MIN(WEEKDAY(order_purchase_timestamp));
	