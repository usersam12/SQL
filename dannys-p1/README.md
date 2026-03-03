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


## SQL Techniques Used
- JOINs, Window Functions, Data Cleaning functions (COALESCE, TRIM)

## Key Findings
Customers A and B are the most valuable of the three examplified by an overall spend of $76 and $74 in a one month period and a high visit frequency of 4 and 6 days visited in one month. Customer A increases their overall value further by increasing their spend by 48% following their membership join date. 

Additionally, the most popular item was ramen with 100% more purchases than the second most popular item, curry. Customer C ordered three total items in January, and all three were ramen. Sushi was the least ordered dish on the menu, and only customer B ordered sushi a second time after their first order date. 

Sushi is thought to be a high profit item because of the inexpensive nature of the ingridients in the dish (rice and seaweed). But, the cost of labor in a roll of sushi is extremely high due to skilled chefs making the dish. Curry on the other hand has more expensive individual ingredients, but can be batched well in advance, and the training required to be a curry chef is substantially less than a sushi chef making execution at volume easier. While cost of goods sold (COGS) was not an included metric within any of the tables, research shows that while sushi has a high gross margin on average (65-75%), it has the lowest net margin (5-10%) of the three menu items.

My reccomendation based on the order frequency of sushi, COGS, and training expenses for sushi chefs, is that sushi should be removed from the menu. This will lead to greater operational efficiency and an ability to focus on ramen and curry which have better margins at scale.

Secondly, there should be a concrete strategy for adding new customers to the rewards program to drive customer retention. One wasn't detailed in the case study prompt, but given customer A's willingness to spend more on return, there should be investment in the strategy. Danny's does well by keeping the reward structure simple at 10 points earned for each $1 spent. A report by the Harvard Business Review claims that on average, a 5% increase in customer retention rates results in a 25%–95% increase in profits.

Sources:
Ramen
https://sg.finance.yahoo.com/news/much-does-bowl-ajisen-ramen-000002827.html?guccounter=1&guce_referrer=aHR0cHM6Ly9jbGF1ZGUuYWkv&guce_referrer_sig=AQAAAFzAdaEYnvO_pizdSuupCl3R9KQr8SS6ubgboI81rq9f79cTVkJHLILRchpTQlodBZ-lsdQVlaBemyyAL2moEaxuBPpUbWn2uEONZFNNBu0OCx83aUFTBsJTGd453fwob22pxn7pa7AjyjQnugZGSLG5LGWhoxjz-mlOWZ75IIRb

Sushi
https://dojobusiness.com/blogs/news/sushi-restaurant-profit-margins

Curry
https://beambox.com/townsquare/average-restaurant-profit-margins

HBR
https://hbr.org/2014/10/the-value-of-keeping-the-right-customers



## Process Notes
### Approach
The first task in approaching this case study was the examine the tables. I reviewed the relationship schema, data types, and individual entries to determine if the data was structured correctly for analysis. I made no alterations to any of the three supplied tables. 

My approach to each question was to both read carefully and consider the itention and consequences of each query. The first two questions were simple asking how much does each customer spend and how many days has each customer visited the restaurant. The first query only required a single join, while the second required none at all. 

By the third question, which asks for the first item purchased by each customer, I noticed that the answer became difficult because customers were purchasing more than one item at once. This required the use of a window function in order to partition by customer to make sure only one item was listed. I used ROW_NUMBER() in order to rank the sales for each customer.

This same issue appeared in question five, when the study asked for the most popular item for each customer. This required changing the window function to RANK() and counting the product_id from the sales table. 

By question six, the study added the members table in order to find the first item purchased immediatly after the customer became a member. This information is important in determining how best to retain the individual customer, including tailoring rewards to the individual. What became challenging in this question was making sure to include a WHERE() clause within the within the subquery as opposed to including this in the outside query. Originally, I made the mistake of placing it in the outside, which assigned the rank of 1 to the first purchase the customer ever made. I saw this result, and quickly adjusted. Question seven was very similar, and didn't require the same problem-solving.

Question eight was a good excersize in data formatting. The question asks for both item quantity and customer spend after membership in the same query. This required two joins, and a COALESCE() function to clean the spend column, which included an endless line of decimals.

Questions nine and ten were the most difficult in that a points value had to be assigned to a dollar value. At first, I felt each individual item should be assigned a binary value which could then be multiplied based on the item type. This failed as the points assigned in this case would be 1 point for ever dollar spent, not 10 points for every dollar spent. The answer was now clearly to create a CASE WHEN statement where sushi could be multiplied by 2 on its own, and all other menu items could be in the ELSE statement. Question 10 was very similar, but required adding two clauses which filtered date: the 2 times multiplier for the first week, and the total points only within January. The date filter for the week after joining was placed within the subquery, and the filter for January was placed outside. This allowed the multiplier to be calculated first, shrinking the volume of data being queried.


### Challenges

### What I'd do differently in the future

I would have performed larger-scale research on the fast-casual restaurant incdustry in order to gain a better understanding of the business beforehand. My industry research was done after the fact, and I believe prior research could have helped lead to better suggestions and questions earlier in the project.
