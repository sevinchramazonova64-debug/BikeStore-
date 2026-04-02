Key Metrics and Insights: 
Total Revenue
Definition: Calculates the total revenue generated from all sales transactions.
DAX Example:
Total Revenue = 
SUMX(
    order_items,
    order_items[quantity] * order_items[list_price] * (1 - order_items[discount])
)
Insight:
Shows overall financial performance of the business.
Helps evaluate revenue trends and overall business growth.
________________________________________
Total Orders
Definition: Counts the total number of orders placed.
DAX Example:
Total Orders = COUNT(orders[order_id])
Insight:
Indicates business activity and demand levels.
Useful for identifying peak sales periods.
________________________________________
Total Customers
Definition: Counts the number of unique customers.
DAX Example:
Total Customers = DISTINCTCOUNT(customers[customer_id])
Insight:
Shows customer base size.
Helps track customer growth and acquisition.
________________________________________
Avg Order Value
Definition: Calculates the average revenue per order.
DAX Example:
Avg Order Value = DIVIDE([Total Revenue], [Total Orders])
Insight:
Measures how much customers spend on average per order.
Useful for improving pricing and upselling strategies.
________________________________________
Category Share %
Definition: Calculates the percentage contribution of each category to total revenue.
DAX Example:
Category Share % = 
DIVIDE(
    [Total Revenue],
    CALCULATE([Total Revenue], ALL(categories))
)
Insight:
Shows which categories contribute most to total revenue.
Helps identify high-performing product segments.

Top 5 Products (by Sales Amount)
Definition: Shows the top 5 products with the highest total sales amount.
DAX Example:
Top 5 Products = 
CONCATENATEX(
    TOPN(5, 'Sales', 'Sales'[Sales Amount], DESC),
    'Sales'[Product Name],
    ", "
)
Insight:
•	Helps identify which products generate the most revenue. 
•	Useful for inventory planning, promotions, and marketing focus.

Total Sales CY (Current Year)
Definition: Calculates the total sales amount for the current year.
DAX Example:
Total Sales CY = 
CALCULATE(
    SUM('Sales'[Sales Amount]),
    YEAR('Sales'[Order Date]) = YEAR(TODAY())
)
Insight:
•	Shows the total revenue generated in the current year. 
•	Helps track yearly performance and compare against previous years or targets.

