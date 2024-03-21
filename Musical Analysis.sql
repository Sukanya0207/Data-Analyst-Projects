USE music;
#  Set 1 - Easy
# ------------------------------------------------------------------------------------------------------------------------------------
-- 1. Who is the senior most employee based on job title?
SELECT * FROM employee;
SELECT title, last_name, first_name
FROM employee
ORDER BY levels DESC
LIMIT 1;
# ------------------------------------------------------------------------------------------------------------------------------------
-- 2. Which countries have the most Invoices?
select * from invoice;
SELECT COUNT(*) 'TotalCountry', billing_country 
   from 
invoice 
   Group by 
billing_country 
order by 'TotalCountry' Desc;
# ------------------------------------------------------------------------------------------------------------------------------------
-- 3. What are top 3 values of total invoice?
SELECT total 
   from 
invoice group by total 
   order by total 
desc limit 3;
# ------------------------------------------------------------------------------------------------------------------------------------
-- 4. Which city has the best customers? We would like to throw a promotional Music 
SELECT billing_city, SUM(total) 'total invoices' 
   from 
invoice group by 
billing_city order by 'total invoice' desc limit 1;
# ------------------------------------------------------------------------------------------------------------------------------------
-- 5. Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals
SELECT * FROM invoice; 
-- part II 
SELECT billing_city, SUM(total) 'total invoice' from invoice
group by billing_city order by 'total invoice' desc;
# ------------------------------------------------------------------------------------------------------------------------------------
-- 6. Who is the best customer? The customer who has spent the most money will be 
-- declared the best customer. Write a query that returns the person who has spent the most money
select * from customer;
SELECT c.customer_id, c.first_name, c.last_name, 
  SUM(i.total) from customer c JOIN invoice i 
ON i.customer_id = c.customer_id group by c.customer_id, 
  c.first_name, c.last_name order by total DESC limit 1;
# ------------------------------------------------------------------------------------------------------------------------------------
-- 7. What is the total quantity of all the invoice lines?
SELECT SUM(quantity) AS TotalQuantity
FROM invoice_line;  
# ------------------------------------------------------------------------------------------------------------------------------------
-- SET 2. MEDIUM 
# ------------------------------------------------------------------------------------------------------------------------------------
-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A
SELECT * from genre;
SELECT * FROM track;
SELECT * FROM artist;
select * from invoice_line;
select Distinct c.customer_id, c.email, c.first_name, c.last_name FROM customer c 
  join invoice i on c.customer_id = i.invoice_id 
  join invoice_line il on i.invoice_id = il.invoice_id 
WHERE track_id in (SELECT track_id from 
track t join genre g on t.genre_id = g.genre_id 
  where g.name = 'Rock' ) order by email;
# -------------------------------------------------------------------------------------------------------------------------------------
-- 2. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands
SELECT * from artist;
SELECT a.artist_id, a.name, 
  COUNT(a.artist_id) No_of_songs from track t JOIN album2 ab 
  ON ab.album_id = t.album_id JOIN artist a on
  a.artist_id = ab.artist_id JOIN genre g on 
  g.genre_id = t.genre_id where g.name LIKE 'Rock'
  group by a.artist_id order by No_of_songs
  DESC limit 10;
# -------------------------------------------------------------------------------------------------------------------------------------
-- 3. Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
SELECT * FROM playlist_track;
select * from track;
SELECT name, milliseconds from track where milliseconds > 
  (select AVG(milliseconds) Avg_song_length from track) 
order by milliseconds desc;
# ------------------------------------------------------------------------------------------------------------------------------------
-- 4. List all the tracks of an album, including the track name, composer, and the length of the track in milliseconds.
SELECT 
    t.name  TrackName, 
    t.composer AS Composer, 
    t.milliseconds AS MillisecondsLength
FROM 
    track t
INNER JOIN 
    album2 alb ON t.album_id = alb.album_id
Group by t.name order by t.milliseconds;
# -------------------------------------------------------------------------------------------------------------------------------------
-- SET 3. ADVANCE 
-- 1. Find how much amount spent by each customer on artists? Write a query to returncustomer name, artist name and total spent
SELECT * FROM customer;
select * from invoice;
SELECT * FROM invoice_line;

WITH top_artist AS (
    SELECT
        a.artist_id AS top_artist_id,
        a.name AS top_artist_name,
        SUM(il.unit_price * il.quantity) AS total_sales
    FROM
        invoice_line il
    JOIN
        track t ON t.track_id = il.track_id
    JOIN
        album2 alb ON alb.album_id = t.album_id
    JOIN
        artist a ON a.artist_id = alb.artist_id
    GROUP BY
        1, 2
    ORDER BY
        3 DESC
    LIMIT 1
)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ta.top_artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM
    invoice i
JOIN
    customer c ON c.customer_id = i.customer_id
JOIN
    invoice_line il ON il.invoice_id = i.invoice_id
JOIN
    track t ON t.track_id = il.track_id
JOIN
    album2 alb ON alb.album_id = t.album_id
JOIN
    top_artist ta ON ta.top_artist_id = alb.artist_id
GROUP BY
    1, 2, 3, 4
ORDER BY
    5 DESC;
# -------------------------------------------------------------------------------------------------------------------------------------
-- 2. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. 
-- Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres
WITH
  sales_per_country AS (
    SELECT
      COUNT(*) AS purchases_per_genre,
      customer.country,
      genre.name,
      genre.genre_id
    FROM
      invoice_line
    JOIN
      invoice ON invoice.invoice_id = invoice_line.invoice_id
    JOIN
      customer ON customer.customer_id = invoice.customer_id
    JOIN
      track ON track.track_id = invoice_line.track_id
    JOIN
      genre ON genre.genre_id = track.genre_id
    GROUP BY
      2, 3, 4
    ORDER BY
      2
  ),
  max_genre_per_country AS (
    SELECT
      MAX(purchases_per_genre) AS max_genre_number,
      country
    FROM
      sales_per_country
    GROUP BY
      2
    ORDER BY
      2
  )

SELECT
  spc.*
FROM
  sales_per_country spc
JOIN
  max_genre_per_country mgpc ON spc.country = mgpc.country
WHERE
  spc.purchases_per_genre = mgpc.max_genre_number;
# -------------------------------------------------------------------------------------------------------------------------------------
# 3. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount
WITH CustomersWithCountry AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        i.billing_country,
        SUM(i.total) AS total_spending,
        ROW_NUMBER() OVER (PARTITION BY i.billing_country ORDER BY SUM(i.total) DESC) AS RowNo
    FROM
        invoice i
    JOIN
        customer c ON c.customer_id = i.customer_id
    GROUP BY
        c.customer_id, c.first_name, c.last_name, i.billing_country
    ORDER BY
        i.billing_country ASC, total_spending DESC
)

SELECT
    *
FROM
    CustomersWithCountry
WHERE
    RowNo <= 1;
# -------------------------------------------------------------------------------------------------------------------------------------
# 4. Find the playlist that contains the most unique tracks from all playlists.
SELECT 
    p.playlist_id, 
    p.name PlaylistName, 
    COUNT(DISTINCT pt.track_id) AS UniqueTrackCount
FROM 
    playlist p
INNER JOIN 
    playlist_track pt ON p.playlist_id = pt.playlist_id
GROUP BY 
    p.playlist_id, 
    p.name
ORDER BY 
    UniqueTrackCount DESC
LIMIT 1; 
# -------------------------------------------------------------------------------------------------------------------------------------
# 5. Find all the tracks that are played by at least 10 customers, including the track name, composer, 
-- and the number of customers who played the track.
SELECT 
    t.name TrackName, 
    t.composer  Composer, 
    COUNT(DISTINCT c.customer_id)  CustomerCount
FROM 
    track t
INNER JOIN 
    invoice_line il ON t.track_id = il.track_id
INNER JOIN 
    invoice i ON il.invoice_id = i.invoice_id
INNER JOIN 
    customer c ON i.customer_id = c.customer_id
GROUP BY 
    t.track_id
HAVING 
    COUNT(DISTINCT c.customer_id) >= 10;

  
 
  


    

