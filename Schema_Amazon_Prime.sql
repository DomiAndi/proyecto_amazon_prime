CREATE TABLE amazon_prime
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(10000),
    casts        VARCHAR(10000),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    year_added	VARCHAR(10),
	month_added  VARCHAR(10)
);

select * from amazon_prime;

-- Count the Number of Movies vs TV Shows
SELECT 
    type,
    COUNT(*)
FROM amazon_prime
GROUP BY 1;

-- Find the Most Common Rating for Movies and TV Shows

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM amazon_prime
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;	

-- List All Movies Released in a Specific Year (e.g., 2020)

SELECT * 
FROM amazon_prime
WHERE release_year = 2020;

-- Find the Top 5 Countries with the Most Content on Amazon Prime

SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM amazon_prime
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;

--  Identify the Longest Movie

SELECT 
    *
FROM amazon_prime
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;

-- List All TV Shows with More Than 5 Seasons

SELECT *
FROM amazon_prime
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

-- Count the Number of Content Items in Each Genre

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM amazon_prime
GROUP BY 1;

-- List All Movies that are Documentaries

SELECT * 
FROM amazon_prime
WHERE listed_in LIKE 'Documentary';

-- Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in United States

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM amazon_prime
WHERE country = 'United States'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;