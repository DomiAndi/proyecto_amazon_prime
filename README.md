# Amazon Prime Análisis de datos de películas y programas de televisión utilizando SQL

## Descripción general
Este proyecto implica un análisis exhaustivo de los datos de películas y programas de televisión de Amazon Prime utilizando SQL. 
El objetivo es extraer información valiosa y responder diversas preguntas comerciales basadas en el conjunto de datos. 
El siguiente archivo README proporciona una descripción detallada de los objetivos, problemas comerciales, soluciones, hallazgos y conclusiones del proyecto.

## Objetivos

- Analizar la distribución de tipos de contenidos (películas vs programas de televisión).
- Identificar las clasificaciones más comunes de películas y programas de televisión.
- Enumerar y analizar contenido según años de lanzamiento, países y duraciones.

## Dataset

Los datos para este proyecto provienen del conjunto de datos de Kaggle:

- **Enlace del conjunto de datos:** [Conjunto de datos de películas](https://www.kaggle.com/datasets/shivamb/amazon-prime-movies-and-tv-shows)

## Schema

```sql
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
```
## Problemas y soluciones empresariales

### 1. Cuente la cantidad de películas vs series

```sql
SELECT 
    type,
    COUNT(*)
FROM amazon_prime
GROUP BY 1;
```

**Objective:** Determinar la distribución de tipos de contenido en Amazon Prime.

### 2. Encuentre la clasificación más común para películas y programas de televisión

```sql
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
```

**Objetivo:** Identificar la calificación que ocurre con más frecuencia para cada tipo de contenido.

### 3. Enumere todas las películas estrenadas en un año específico (por ejemplo, 2020)

```sql
SELECT * 
FROM amazon_prime
WHERE release_year = 2020;
```

**Objetivo:** Recuperar todas las películas estrenadas en un año específico.

### 4. Encuentre los 5 países principales con más contenido en Amazon Prime

```sql
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
```

**Objetivo:** Identificar los 5 países principales con la mayor cantidad de elementos de contenido.

### 5. Identify the Longest Movie

```sql
SELECT 
    *
FROM amazon_prime
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```

**Objetivo:** Encuentra la película de mayor duración.
