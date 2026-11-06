# Olist E-Commerce Analysis: 100k Brazilian Orders (2016–2018)

An end-to-end analysis of the Olist public e-commerce dataset, from raw CSVs to a Power BI dashboard, to understand sales growth, revenue drivers, delivery performance and customer loyalty.

![Olist dashboard](images/dashboard.png)

## Business questions

1. How are sales growing over time?
2. Which product categories and regions drive revenue?
3. Does delivery performance affect customer satisfaction?
4. How loyal are customers, and which groups should marketing target?

## Key findings and recommendations

**1. Growth is steady in 2018.** From January to August, revenue runs about 1M per month above the same month of 2017. The data ends in August 2018, so September should not be compared.
→ *Recommendation:* the growth trend is healthy; track it with full-year data once available.

**2. Revenue is concentrated in São Paulo.** SP accounts for about 38% of total sales, and the second state is more than 3M behind. The top 3 product categories together bring in more than 3M in revenue.
→ *Recommendation:* SP is both the main market and the main risk. It is the biggest state in Brazil, but there is room to grow in other markets.

**3. Late deliveries lower customer satisfaction.** Review scores fall clearly on late orders, and 7.9% of orders arrive late.
→ *Recommendation:* improving logistics in the slowest states protects customer satisfaction.

**4. Very few customers come back.** Only 3.1% of customers place a second order. Even the biggest buyer, who spent about 14k, bought only once. Repeat rates barely change by state (3.0% to 3.4%), so state does not separate loyal from non-loyal customers.
→ *Recommendation:* campaigns should not be state-specific. The biggest opportunity is converting one-time buyers, not necessarily winning new ones.

## Tools and workflow

**Python (pandas) → MySQL → Power BI**

- **Python / pandas:** structural cleaning of the 7 raw CSVs (types, dates, category translation), quick to inspect and iterate on.
- **MySQL:** joins, window functions and aggregations across tables, reusable as views.
- **Power BI:** interactive dashboard on top of the SQL views, to communicate the results.

## 1. Data cleaning (Python / pandas)

`python/clean.ipynb` cleans the 7 tables one by one (customers, orders, order items, payments, reviews, products, sellers):

- Inspected each table (`info()`) and checked missing values and duplicates.
- Converted date columns to datetime: 5 in orders, 1 in order items, 2 in reviews.
- Products: merged with the category translation table to get English names, dropped the Portuguese column, and labelled missing categories as `unknown`.
- Kept the full reviews table; orders with more than one review are averaged later in SQL.
- Saved each cleaned table as a UTF-8 CSV and loaded them into MySQL.

Derived fields such as delivery days and the late-delivery flag are calculated in SQL, not in pandas.

## 2. SQL analysis

| File | What it does |
|---|---|
| `sql/01_tables_and_import.sql` | Creates the 7 tables and loads the cleaned CSVs |
| `sql/02_aggregated_tables.sql` | Builds one-row-per-order tables for payments (sum), items (count) and reviews (average score), so joins do not duplicate rows |
| `sql/03_total_table_view.sql` | Creates the `total_table` view (one row per order, with delivery status and delivery time) used by Power BI |

The `sql/queries/` folder answers 11 business questions:

| # | File | Question |
|---|---|---|
| 1 | `q01_kpis.sql` | Headline KPIs |
| 2 | `q02_monthly_revenue.sql` | Monthly revenue, running total, month-on-month growth |
| 3 | `q03_category_revenue.sql` | Revenue and rating by product category |
| 4 | `q04_by_state.sql` | Delivery time and late % by state |
| 5–6 | `q05_q06_delivery_reviews.sql` | Late vs on-time reviews; review score by delivery-time bucket |
| 7 | `q07_payment_methods.sql` | Payment methods and share of value |
| 8 | `q08_top10_customers.sql` | Top 10 customers by spend |
| 9 | `q09_repeat_orders.sql` | Repeat-purchase rate |
| 10 | `q10_top_sellers.sql` | Top 10 sellers by revenue |
| 11 | `q11_weekdays.sql` | Orders by day of week |

## 3. Dashboard (Power BI)

The dashboard is organised around the four business questions above and ends with a recommendations box.

**Data model.** Power BI loads two SQL views plus five base tables:

- `total_table` (view): one row per order, with payment, items, review, delivery status and delivery time.
- `customer_rfm` (view): one row per customer (`customer_unique_id`), used for the loyalty analysis.
- `customers`, `orders`, `order_items`, `order_payment`, `products`: base tables used for state, category and revenue breakdowns.

**DAX measures** (in a separate `medidas` table):

```dax
Total Revenue = SUM('olist order_items'[price])
```

```dax
Avg Order Value =
DIVIDE(
    SUM('olist order_items'[price]),
    DISTINCTCOUNT('olist order_items'[order_id])
)
```

```dax
AVG_delivery = AVERAGE('olist total_table'[delivery_time])
```

```dax
AVG_review = AVERAGE('olist total_table'[review])
```

Revenue in the dashboard is the sum of item prices, so it excludes freight.

## Limitations

- **Limited time frame.** The data ends in August 2018, so full-year 2017 and 2018 cannot be compared, and 2016 has very few orders. This dataset is used for learning purposes only.
- **One marketplace, one sample.** Results describe Olist orders in this period and should not be generalised to Brazilian e-commerce as a whole.
- **No customer attributes.** There is no data such as gender or age, and the state is where the purchase was made. As a result, 30 customers have two states linked to the same `customer_unique_id`. For simplicity, I used their latest purchase to calculate the repeat-order percentage per state.
- **Repeat rate is time-limited.** Customers who bought shortly before the data ends had little time to come back, so the 3.1% may be underestimated.
- **Two revenue definitions.** The Power BI measures use the sum of item prices (without freight), while the SQL queries use total payment value (with freight). There is also no cost or margin data, so profitability cannot be analysed.
- **Delivery and reviews show association, not cause.** Late orders get lower reviews, but delivery time also varies with distance, category and seller, which this analysis does not control for.
- **SP concentration is not adjusted for population.** SP is the most populous state, so its 38% share partly reflects its size.
- **Geolocation data not used.** The dataset includes a geolocation table that was left out, so distances between sellers and customers are not analysed.

## Possible next steps

- Compare repeat-purchase rates for customers whose first order was late versus on time.
- Run a cohort analysis (retention by first-purchase month).
- Normalise revenue by state population to see which states are under-served.
- Use the geolocation table to map delivery time by region and test whether seller–customer distance explains late deliveries.

## Data source

Olist, *Brazilian E-Commerce Public Dataset by Olist*, Kaggle: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data

## How to reproduce

1. Download the dataset from Kaggle and place the raw CSVs in an `archive/` folder.
2. Run `python/clean.ipynb` to create the cleaned CSVs.
3. Run `sql/01_tables_and_import.sql` in MySQL (update the file paths; `local_infile` must be enabled).
4. Run `sql/02_aggregated_tables.sql`, then `sql/03_total_table_view.sql`.
5. Run the files in `sql/queries/` to reproduce each analysis.
6. Open the Power BI file and refresh it against the MySQL views.
