# Danny's Diner

## Abstract
This SQL case study examines the ficticious Danny's Diner, a new asian-fusion restaurant with a blooming customer base and new rewards program.


## Dataset
Source:
https://8weeksqlchallenge.com/case-study-1/
The dataset is seperated into three tables: "sales", "menu", and "member". "sales" contains 'customer_id', 'order_date', and 'product_id'. "menu" contains 'product_id', 'product_name', and 'price' "members" contains 'customer_id' and 'join_date'.


## Key Questions
What are the spending habits of three frequent customers of Danny's Diner?
Which customers will then gain rewards points to create returning customers?
Should Danny's Diner make changes to their menu based on customer data?

## SQL Techniques Used
JOINs, Window Functions, Data Cleaning functions (COALESCE, TRIM)

## Key Findings

Customers A and B are the most valuable of the three, with overall spend of $76 and $74 respectively over a one-month period and high visit frequencies of 4 and 6 days. Customer A further demonstrates strong engagement, increasing spend by 48% following their membership join date.
The most popular item was ramen, with 100% more purchases than the second most popular item, curry. Notably, all three of Customer C's orders in January were ramen. Sushi was the least ordered item overall, with only Customer B ordering it more than once.

While COGS was not included in the dataset, industry research indicates that sushi restaurants typically operate with gross margins of 60–70% but net profit margins of only 5–20% depending on format (Dojo Business) — largely driven by the high labor cost of skilled preparation. Ramen and curry, by contrast, are more scalable dishes that can be prepared in volume with less specialized labor, supporting stronger margins at scale.
Based on order frequency, labor costs, and net margin profile, I recommend removing sushi from the menu to improve operational efficiency and allow greater focus on ramen and curry.

Additionally, Danny's should develop a concrete strategy for enrolling new customers in the rewards program. Customer A's post-membership spending increase suggests meaningful retention upside. The current structure — 10 points per $1 spent — is appropriately simple. Research by Frederick Reichheld of Bain & Company shows that increasing customer retention rates by just 5% can increase profits by 25–95% (Harvard Business Review), making investment in this area well worth prioritizing.

Citations:
Gallo, A. (2014, October 29). The value of keeping the right customers. Harvard Business Review. https://hbr.org/2014/10/the-value-of-keeping-the-right-customers

Dojo Business Team. (2025, June 16). What are the profit margins of sushi restaurants? BusinessDojo. https://dojobusiness.com/blogs/news/sushi-restaurant-profit-margins



## Process Notes
### Approach
The first step in approaching this case study was to examine the tables. I reviewed the relationship schema, data types, and individual entries to determine whether the data was structured correctly for analysis. No alterations were made to any of the three supplied tables.
My approach to each question was to read carefully and consider the intent and consequences of each query. The first two questions were straightforward — asking how much each customer spent and how many days each had visited the restaurant. The first query required a single join, while the second required none.

By the third question, which asks for the first item purchased by each customer, the problem became more complex because customers were purchasing multiple items in the same visit. This required a window function partitioned by customer to ensure only one item was returned per person. I used ROW_NUMBER() to rank each customer's purchases chronologically.

The same challenge appeared in question five, which asks for the most popular item per customer. This was resolved by switching to RANK() and counting product_id from the sales table.

Question six introduced the members table to find the first item purchased after a customer joined. This is meaningful context for retention strategy, as it can inform how rewards are tailored to individual customers. The key challenge here was placing the WHERE clause inside the subquery rather than the outer query — a mistake I initially made, which caused the rank of 1 to be assigned to each customer's very first purchase overall rather than their first post-membership purchase. I caught the error quickly and corrected it. Question seven followed a similar structure and didn't present the same difficulty.

Question eight was a useful exercise in data formatting. The query asks for both item quantity and total spend after membership in a single output, which required two joins and a COALESCE() function to clean a spend column that was returning excessive decimal places.

Questions nine and ten were the most challenging, as a points value had to be derived from dollar spend. My initial instinct was to assign a binary flag to each item and multiply from there — but this produced 1 point per dollar rather than the correct 10. The solution was a CASE WHEN statement that applied a 2x multiplier to sushi specifically, with all other items handled in the ELSE clause. Question ten built on this logic but added two date filters: the 2x multiplier for the first week after joining, and a total points cap within January. Placing the week filter inside the subquery and the January filter outside meant the multiplier was calculated first on a smaller dataset, improving both accuracy and efficiency.

### What I'd do differently in the future

I would have performed larger-scale research on the fast-casual restaurant incdustry in order to gain a better understanding of the business beforehand. My industry research was done after the fact, and I believe prior research could have helped lead to better suggestions and questions earlier in the project.
