SELECT*FROM books; 
SELECT*FROM customers;
SELECT*FROM orders;

-- 1) Retrive all books in the "fiction" genre: 
SELECT*FROM books 
WHERE Genre = "Fiction";

-- 2) Find books published after the year 1950:
SELECT*FROM books 
WHERE Published_Year > 1950
ORDER BY Published_Year ASC;

-- 3) List all customers from the Canada:
SELECT*FROM customers 
WHERE Country ="Canada"; 

-- 4) Show orders placed in November 2023: 
SELECT*FROM orders 
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30'
ORDER BY Order_Date ASC;

-- 5) Retrive the total stock of books available: 
SELECT SUM(stock) AS Total_Stock 
FROM books;

-- 6) Find the details of the most epensive books:
SELECT*FROM books
WHERE Price = (
SELECT MAX(Price)
FROM books
); 
-- OR 
SELECT*FROM books ORDER BY Price DESC LIMIT 1; 

-- 7) Show all customers who ordered more than 1 quantity of a book: 
SELECT*FROM orders 
WHERE Quantity > 1
ORDER BY Quantity DESC; 

-- 8) Retrive all orders where the total amount exceeds $20: 
SELECT*FROM orders
WHERE Total_Amount > 20 
ORDER BY Total_Amount DESC;

-- 9) List all genres available in the books table: 
SELECT DISTINCT genre FROM books; 

-- 10) Find the book with lowest stock: 
SELECT*FROM books 
ORDER BY Stock
LIMIT 1;

-- 11) Calaculate the total revenue generated from all orders:
SELECT SUM(Total_Amount) AS Total_Revenue
FROM Orders;

-- ADVANCE QUESTIONS :

-- 1) Retrieve the total number of books sold for each genre: 
SELECT Genre, SUM(Quantity)AS Total_Books_Sold
FROM books 
JOIN orders 
ON books.Book_ID = orders.Book_ID 
GROUP BY Genre
ORDER BY SUM(Quantity) DESC;

-- 2) Find the average price of the books in the "Fnatasy" genre:
SELECT Genre, AVG(Price)
FROM books 
WHERE Genre = 'Fantasy'; 

-- 3) List customers who have placed at least 2 orders:
SELECT o.Customer_ID, c.Name, COUNT(order_ID) AS Order_Count
FROM orders o
JOIN customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Name
HAVING COUNT(order_ID)>= 2
ORDER BY COUNT(*) DESC;

-- 4) Find the most frequently ordered book: 
SELECT b.Book_ID, b.Title, COUNT(o.Book_ID) AS Order_Count
FROM orders o
JOIN books b
ON o.Book_ID = b.Book_ID
GROUP BY b.Title, b.Book_ID
ORDER BY COUNT(o.Book_ID) DESC
LIMIT 1; 

-- 5) Show the top 3 most expensive books of the 'Fantasy' Genre: 
SELECT*FROM books
WHERE Genre = 'Fantasy' 
ORDER BY Price DESC 
LIMIT 3; 

-- 6) Retrive the total quantity of books sold be each author: 
SELECT b.Author, SUM(o.Quantity) AS Total_Books_Sold
FROM books b
JOIN orders o
ON b.Book_ID=o.Book_ID
GROUP BY b.Author
ORDER BY SUM(o.Quantity) DESC;

-- 7) List the cities where customres who spent over $30 are located:
SELECT c.city, ROUND( SUM(o.Total_Amount),2 )
FROM customers c
JOIN orders o
ON  c.Customer_ID=o.Customer_ID
GROUP BY c.city
HAVING SUM( o.Total_Amount) > 30 
ORDER BY SUM(o.Total_Amount) DESC;

-- 8) Find the customer who spent the most on orders:
SELECT c.Customer_ID, c.Name, ROUND( SUM(o.Total_Amount),2 )
FROM customers c
JOIN orders o
ON  c.Customer_ID=o.Customer_ID
GROUP BY c.Name, c.Customer_ID
ORDER BY SUM(o.Total_Amount) DESC
LIMIT 1; 

-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_ID, b.Title, SUM(b.Stock) AS Total_Stock, COALESCE(SUM(o.Quantity), 0) AS Total_Order_Quantity, 
SUM(b.Stock) - COALESCE(SUM(o.Quantity), 0) AS remaining_Quanitity
FROM orders o
LEFT JOIN books b
ON o.Book_ID=b.Book_ID
GROUP BY b.book_ID, b.Title
ORDER BY b.book_ID ASC;
