-- Netflix Project

CREATE TABLE netflix 
(
	show_id	VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(208),
	cast VARCHAR(1000),
	country	VARCHAR(150),
	date_added VARCHAR(50),
	release_year VARCHAR(1
	rating VARCHAR(10)
	duration VARCHAR(10)
	listed_in VARCHAR(10)
	description 

)

SELECT * FROM netflix;


SELECT
	COUNT (*) as total_content
FROM netflix;


SELECT
	DISTINCT type
FROM netflix;


SELECT * FROM netflix;


-- 15 Business Problems

--1. Count the number of movies vs tv shows
SELECT 
	type,
	COUNT(*)  as total_content
FROM netflix
GROUP BY type;

--2. find the most common rating for movies and tv shows
SELECT
	type,
	rating
FROM
(
	SELECT
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1,2
) as t1
WHERE
	ranking = 1

--3. list all movies released in a specific year

--filter 2020
--movies
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020
	
--4. find the top 5 countries with the most content on Netflix
SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5



--5. identify he longest movies?
SELECT * FROM netflix
WHERE
	type = 'Movie'
	AND
	duration = (SELECT MAX (duration ) FROM netflix)

--6. find content added in last 5 years
SELECT 
	*
FROM netflix
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY')>= CURRENT_DATE - INTERVAL '5 years'



--7. find all the movies/tv shows by director 'Rajiv Chilaka'
SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'



--8. list all tv shows with more than 5 seasons
SELECT * FROM netflix
WHERE 
	type = 'TV Show' 
	AND
	SPLIT_PART(duration, ' ',1) ::numeric > 5 



--9. count the number ofcontent items in each genre
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1



--10. find each year and the avg numbers of content release by India on netlfix. 
--return top 5 year with highest avg content release;
SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*)FROM netflix WHERE country = 'India')::numeric * 100 
	,2)as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1



--11. list all movies that are documentaries
SELECT * FROM netflix
WHERE
	listed_in ILIKE '%documentaries%'
	


--12. find all content without a director
SELECT * FROM netflix
WHERE 
	director IS NULL



--13. find how many movies actor 'Salman Khan' appeared in last 10 years
SELECT * FROM netflix
WHERE
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10



--14. find the top 10 actors who appeared in highest numbers of movies in India
SELECT 
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


--15. categorize the content based on the presence of the keywords 'kill' and 'violence' in
--the description field. label content containing these keywords as 'bad' and all other
--content as 'good'. count how many items fall into each category
WITH new_table
AS
(
SELECT 
*,
	CASE
	WHEN 
		description ILIKE '%kill%' OR 
		description ILIKE '%violence%' THEN 'Bad_Content'
		ELSE 'Good_Content'
	END category
FROM netflix
)
SELECT
	category,
	COUNT(*) as total_content
FROM new_table
GROUP BY 1








	

