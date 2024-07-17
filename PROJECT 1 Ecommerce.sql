# PROJECT 1 ----------------------------------------------------------------------------------------------------------------------------
# 3 Run SQL command to see the structure of table
USE ecommerce;
DESC users_data;
# ---------------------------------------------------------------------------------------------------------------------------------
# 4 Run SQL command to select first 100 rows of the database
SELECT * FROM users_data;
SELECT * FROM users_data WHERE type = 'user' LIMIT 100;
# ----------------------------------------------------------------------------------------------------------------------------------
# 5 How many distinct values exist in table for field country and language
SELECT COUNT(DISTINCT country, language) FROM users_data; 
    SELECT DISTINCT country, language FROM users_data;
#------------------------------------------------------------------------------------------------------------------------------------
# 6 Check whether male users are having maximum followers or female users.
SELECT SUM(socialNbFollowers), gender 
         FROM 
users_data GROUP BY gender; 
#  ---------------------------------------------------------------------------------------------------------------------------------
# 7.A Uses Profile Picture in their Profile
SELECT COUNT(*) FROM 
    users_data 
WHERE hasProfilePicture = 'True'; 
# 7.B Uses Application for Ecommerce platform
SELECT COUNT(*) FROM 
    users_data 
WHERE hasAnyApp = 'True'; 
# 7.C Uses Android app
SELECT COUNT(*) FROM 
    users_data 
WHERE hasAndroidApp = 'True'; 

# 7.D Uses ios app
SELECT COUNT(*) FROM 
    users_data 
WHERE hasIosApp = 'True'; 
#-----------------------------------------------------------------------------------------------------------------------------------
# 8 Calculate the total number of buyers for each country and sort the result in descending order of total number of buyers. 
#  (Hint: consider only those users having at least 1 product bought.)
SELECT country, SUM(productsBought) 
    FROM users_data WHERE productsBought > 0
GROUP BY country 
ORDER BY COUNT(productsBought) DESC;
#-----------------------------------------------------------------------------------------------------------------------------------
# 9 Calculate the total number of sellers for each country and sort the result in ascending order of total number of sellers. 
# (Hint: consider only those users having at least 1 product sold.)
SELECT country, SUM(productsSold) 
    FROM users_data WHERE productsSold > 0 
GROUP BY country 
    ORDER BY COUNT(productsSold);
#-----------------------------------------------------------------------------------------------------------------------------------
# 10 Display name of top 10 countries having maximum products pass rate.
SELECT country, SUM(productsPassRate) 
    FROM users_data GROUP BY country 
ORDER BY SUM(productsPassRate) 
   DESC LIMIT 10;
   
   SELECT COUNT(*) 
    FROM users_data GROUP BY country 
ORDER BY SUM(productsPassRate) 
   DESC LIMIT 10;
#-----------------------------------------------------------------------------------------------------------------------------------
# 11 Calculate the number of users on an ecommerce platform for different language choices
SELECT language, COUNT(*)  FROM
    users_data 
GROUP BY language;
#-----------------------------------------------------------------------------------------------------------------------------------
# 12 Check the choice of female users about putting the product in a wishlist or to like socially on an ecommerce platform. 
# (Hint: use UNION to answer this question.)

SELECT COUNT(productsWished), COUNT(socialProductsLiked)  
    FROM users_data 
WHERE gender = 'F'; 

#-----------------------------------------------------------------------------------------------------------------------------------
# 13 Check the choice of male users about being seller or buyer. (Hint: use UNION to solve this question.)
SELECT gender, COUNT(productsBought)
   FROM users_data 
WHERE productsBought > 0 
   AND gender = 'M'
     UNION 
SELECT gender, COUNT(productsSold)
     FROM users_data 
WHERE productsSold > 0 AND gender = 'M';

#-----------------------------------------------------------------------------------------------------------------------------------
# 14 Which country is having maximum number of buyers?
SELECT country, COUNT(productsBought) 
    FROM users_data 
GROUP BY country 
    ORDER BY  
COUNT(productsBought) DESC;
#-----------------------------------------------------------------------------------------------------------------------------------
# 15 List the name of 10 countries having zero number of sellers
SELECT country, productsSold 
    FROM users_data 
WHERE SUM(productsSold)  < 1 
    ORDER BY country 
   LIMIT 10;
#-----------------------------------------------------------------------------------------------------------------------------------
# 16 Display record of top 110 users who have used ecommerce platform recently.
SELECT daysSinceLastLogin 
   FROM users_data 
ORDER BY daysSinceLastLogin 
   ASC LIMIT 110;
#-----------------------------------------------------------------------------------------------------------------------------------
# 17 Calculate the number of female users those who have not logged in since last 100 days. 
SELECT gender, COUNT(daysSinceLastLogin) 
   FROM users_data 
WHERE gender = 'F' 
   AND daysSinceLastLogin > 100;
#-----------------------------------------------------------------------------------------------------------------------------------
# 18 Display the number of female users of each country at ecommerce platform.
SELECT country, COUNT(*) 
   FROM users_data
WHERE gender = 'F' 
   ORDER BY country;
#-----------------------------------------------------------------------------------------------------------------------------------  
# 19 Display the number of male users of each country at ecommerce platform.
SELECT country, COUNT(*) 
   FROM users_data
WHERE gender = 'M' 
   ORDER BY country;
   
#-----------------------------------------------------------------------------------------------------------------------------------  
# 20 Calculate the average number of products sold and bought on ecommerce platform by male users for each country.
SELECT country, 
       AVG(productsSold),
       AVG(productsBought)
	FROM users_data 
WHERE gender = 'M' 
   GROUP BY country;

