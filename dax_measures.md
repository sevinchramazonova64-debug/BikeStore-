Key Metrics and Insights – Power BI Dashboard
1. Total Revenue

Definition: Calculates the total revenue from all sales transactions.
DAX Formula:

Total Revenue = 
SUMX(
    order_items,
    order_items[quantity] * order_items[list_price] * (1 - order_items[discount])
)

Insight:

Shows overall financial performance.
Helps evaluate revenue trends and business growth.
2. Total Orders

Definition: Counts the total number of orders placed.
DAX Formula:

Total Orders = COUNT(orders[order_id])

Insight:

Indicates business activity and demand levels.
Useful for identifying peak sales periods.
3. Total Customers

Definition: Counts the number of unique customers.
DAX Formula:

Total Customers = DISTINCTCOUNT(customers[customer_id])

Insight:

Shows customer base size.
Helps track customer growth and acquisition.
4. Avg Order Value

Definition: Calculates the average revenue per order.
DAX Formula:

Avg Order Value = DIVIDE([Total Revenue], [Total Orders])

Insight:

Measures average spend per order.
Useful for pricing strategies and upselling.
5. Category Share %

Definition: Calculates each category’s contribution to total revenue.
DAX Formula:

Category Share % = 
DIVIDE(
    [Total Revenue],
    CALCULATE([Total Revenue], ALL(categories))
)

Insight:

Shows top-performing categories.
Helps identify focus areas for growth.
6. Top 5 Products (by Sales Amount)

Definition: Shows the top 5 products generating the highest sales.
DAX Formula:

Top 5 Products = 
CONCATENATEX(
    TOPN(5, 'Sales', 'Sales'[Sales Amount], DESC),
    'Sales'[Product Name],
    ", "
)

Insight:

Highlights best-selling products.
Useful for inventory planning, marketing, and promotions.
7. Total Sales CY (Current Year)

Definition: Calculates total sales for the current year.
DAX Formula:

Total Sales CY = 
CALCULATE(
    SUM('Sales'[Sales Amount]),
    YEAR('Sales'[Order Date]) = YEAR(TODAY())
)

Insight:

Tracks yearly revenue performance.
Enables comparison with previous years or targets.

