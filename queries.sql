-- 1) Retrieve all books in the "Fiction" genre
SELECT * FROM books
WHERE Genre = 'Fiction';

-- 2) Find books published after the year 1950
SELECT * FROM books
WHERE Published_Year > 1950;

-- 3) List all customers from Canada
SELECT * FROM customers
WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023
SELECT * FROM orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available
SELECT SUM(Stock) AS Total_Stock
FROM books;

-- 6) Find the details of the most expensive book
SELECT * FROM books
ORDER BY Price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
SELECT DISTINCT c.Customer_ID, c.Name 
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20
SELECT o.Order_ID, o.Customer_ID, SUM(b.Price * o.Quantity) AS Total_Amount 
FROM orders o
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY o.Order_ID, o.Customer_ID
HAVING SUM(b.Price * o.Quantity) > 20;

-- 9) List all genres available in the Books table
SELECT DISTINCT Genre
FROM books;

-- 10) Find the book with the lowest stock
SELECT * FROM books
ORDER BY Stock ASC
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders
SELECT SUM(b.Price * o.Quantity) AS Total_Revenue 
FROM orders o
JOIN books b ON o.Book_ID = b.Book_ID;

-- 12) Total Number of Books Sold for Each Genre
SELECT b.Genre, SUM(o.Quantity) AS Total_Books_Sold 
FROM orders o
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre
ORDER BY Total_Books_Sold DESC;

-- 13) Calculate the Average Price of Books in the Fantasy Genre
SELECT AVG(Price) AS Average_Price_Fantasy 
FROM books
WHERE Genre = 'Fantasy';

-- 14) Retrieve Customers Who Have Placed at Least Two Orders
SELECT c.Name, COUNT(o.Order_ID) AS Number_of_Orders 
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2;

-- 15) Identify the Most Frequently Ordered Book
SELECT b.Title, COUNT(o.Order_ID) AS Order_Count 
FROM orders o
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY Order_Count DESC
LIMIT 1;

-- 16) Fetch the Top 3 Most Expensive Books in the Fantasy Genre
SELECT Title, Price 
FROM books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 17) Calculate the Total Quantity of Books Sold by Each Author
SELECT b.Author, SUM(o.Quantity) AS Total_Quantity_Sold 
FROM orders o
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY b.Author
ORDER BY Total_Quantity_Sold DESC;

-- 18) Find the Customer Who Spent the Most on Orders
SELECT c.Name, SUM(b.Price * o.Quantity) AS Total_Spent
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY c.Name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 19) Compute the Stock Remaining After Fulfilling Orders
SELECT b.Book_ID, b.Title, (b.Stock - COALESCE(SUM(o.Quantity), 0)) AS Remaining_Stock
FROM books b
LEFT JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title
ORDER BY Remaining_Stock DESC;

-- 20) List Cities Where Customers Who Spent Over $30 Are Local
SELECT c.City 
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY c.City
HAVING SUM(b.Price * o.Quantity) > 30;

-- 21) Retrieve the top 3 best-selling books along with their total sales amount
SELECT b.Title, SUM(o.Quantity) AS Total_Sold, SUM(o.Quantity * b.Price) AS Total_Sales 
FROM orders o
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY Total_Sales DESC
LIMIT 3;

-- 22) Find customers who have spent more than the average order value
SELECT c.Customer_ID, c.Name, SUM(o.Quantity * b.Price) AS Total_Spent 
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY c.Customer_ID, c.Name
HAVING SUM(o.Quantity * b.Price) > (SELECT AVG(o.Quantity * b.Price) FROM orders o JOIN books b ON o.Book_ID = b.Book_ID);

-- 23) Retrieve the books that have never been ordered
SELECT * FROM books 
WHERE Book_ID NOT IN (SELECT DISTINCT Book_ID FROM orders);

-- 24) Find the genre that generated the highest revenue
SELECT b.Genre, SUM(o.Quantity * b.Price) AS Total_Revenue 
FROM books b
JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Total_Revenue DESC
LIMIT 1;

-- 25) Retrieve the customer who placed the earliest order
SELECT c.Customer_ID, c.Name, MIN(o.Order_Date) AS First_Order_Date 
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY First_Order_Date ASC
LIMIT 1;

-- 26) Show the cumulative revenue for each month in 2023 using a window function
SELECT DATE_TRUNC('month', o.Order_Date) AS Order_Month, 
       SUM(b.Price * o.Quantity) AS Monthly_Revenue,
       SUM(SUM(b.Price * o.Quantity)) OVER (ORDER BY DATE_TRUNC('month', o.Order_Date)) AS Cumulative_Revenue
FROM orders o
JOIN books b ON o.Book_ID = b.Book_ID
WHERE o.Order_Date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY Order_Month
ORDER BY Order_Month;

-- 27) Retrieve the latest order for each customer
SELECT DISTINCT ON (o.Customer_ID) o.Customer_ID, c.Name, o.Order_ID, o.Order_Date 
FROM orders o
JOIN customers c ON o.Customer_ID = c.Customer_ID
ORDER BY o.Customer_ID, o.Order_Date DESC;

-- 28) Find customers who have only placed one order
SELECT c.Customer_ID, c.Name 
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) = 1;

-- 29) Retrieve the most expensive book in each genre
SELECT DISTINCT ON (b.Genre) b.Genre, b.Title, b.Price 
FROM books b
ORDER BY b.Genre, b.Price DESC;

-- 30) Find the percentage of total sales each genre contributes
SELECT b.Genre, 
       SUM(o.Quantity * b.Price) AS Genre_Revenue,
       (SUM(o.Quantity * b.Price) * 100) / (SELECT SUM(o.Quantity * b.Price) FROM orders o JOIN books b ON o.Book_ID = b.Book_ID) AS Revenue_Percentage
FROM books b
JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Revenue_Percentage DESC;

-- 31) Identify books that have been ordered in every month of 2023
SELECT b.Title 
FROM books b
JOIN orders o ON b.Book_ID = o.Book_ID
WHERE EXTRACT(YEAR FROM o.Order_Date) = 2024
GROUP BY b.Title
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM o.Order_Date)) = 12;

-- 32) Find the customer who placed the most expensive single order
SELECT o.Customer_ID, c.Name, o.Order_ID, SUM(o.Quantity * b.Price) AS Order_Total
FROM orders o
JOIN customers c ON o.Customer_ID = c.Customer_ID
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY o.Customer_ID, c.Name, o.Order_ID
ORDER BY Order_Total DESC
LIMIT 1;

-- 33) Retrieve books that have been ordered more than the average order quantity
SELECT b.Title, SUM(o.Quantity) AS Total_Ordered 
FROM books b
JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Title
HAVING SUM(o.Quantity) > (SELECT AVG(Quantity) FROM orders);

-- 34) Identify customers who have purchased books from at least 3 different genres
SELECT c.Customer_ID, c.Name, COUNT(DISTINCT b.Genre) AS Unique_Genres 
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(DISTINCT b.Genre) >= 3;

-- 35) Find books that have at least 5 orders but still have stock remaining
SELECT b.Book_ID, b.Title, SUM(o.Quantity) AS Total_Sold, b.Stock 
FROM books b
JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock
HAVING SUM(o.Quantity) >= 5 AND b.Stock > 0;

-- 36) Retrieve books where the total sales revenue is more than the average revenue of all books
SELECT b.Title, SUM(o.Quantity * b.Price) AS Total_Revenue 
FROM books b
JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Title
HAVING SUM(o.Quantity * b.Price) > (SELECT AVG(o.Quantity * b.Price) FROM orders o JOIN books b ON o.Book_ID = b.Book_ID);

-- 37) Show the most recent 5 orders with customer details
SELECT o.Order_ID, c.Name, o.Order_Date, SUM(b.Price * o.Quantity) AS Total_Cost
FROM orders o
JOIN customers c ON o.Customer_ID = c.Customer_ID
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY o.Order_ID, c.Name, o.Order_Date
ORDER BY o.Order_Date DESC
LIMIT 5;

-- 38) Retrieve customers who ordered the same book more than once on different dates
SELECT o.Customer_ID, c.Name, o.Book_ID, b.Title, COUNT(DISTINCT o.Order_Date) AS Order_Count
FROM orders o
JOIN customers c ON o.Customer_ID = c.Customer_ID
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY o.Customer_ID, c.Name, o.Book_ID, b.Title
HAVING COUNT(DISTINCT o.Order_Date) > 1;

-- 39) Show the bestselling book in each genre
WITH RankedBooks AS (
    SELECT b.Genre, b.Title, SUM(o.Quantity) AS Total_Sold,
           RANK() OVER (PARTITION BY b.Genre ORDER BY SUM(o.Quantity) DESC) AS rnk
    FROM books b
    JOIN orders o ON b.Book_ID = o.Book_ID
    GROUP BY b.Genre, b.Title
)
SELECT Genre, Title, Total_Sold 
FROM RankedBooks
WHERE rnk = 1;

-- 40) Retrieve books that have at least one order but have not been ordered in the last 6 months
SELECT b.Book_ID, b.Title, MAX(o.Order_Date) AS Last_Ordered_Date
FROM books b
JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title
HAVING MAX(o.Order_Date) < CURRENT_DATE - INTERVAL '6 months';
