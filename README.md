![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Microsoft Excel](https://img.shields.io/badge/Microsoft_Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)
![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)

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

### 5. Identificar la película más larga

```sql
SELECT 
    *
FROM amazon_prime
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```

**Objetivo:** Encuentra la película de mayor duración.

### 6. Enumere todos los programas de televisión con más de 5 temporadas

```sql
SELECT *
FROM amazon_prime
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```
**Objetivo:** Identificar programas de TV con más de 5 temporadas.

### 7. Cuente la cantidad de elementos de contenido en cada género

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM amazon_prime
GROUP BY 1;
```

### 8. Enumere todas las películas que son animaciones

```sql
SELECT * 
FROM amazon_prime
WHERE listed_in LIKE '%Animation';
```
**Objetivo:** Recuperar todas las películas clasificadas como animaciones.

### 9. Encuentre los 10 actores principales que han aparecido en la mayor cantidad de películas producidas en Estados Unidos

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM amazon_prime
WHERE country = 'United States'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```

**Objetivo:** Identificar los 10 actores principales con más apariciones en películas producidas en Estados Unidos.

## Hallazgos y conclusiones

- **Distribución de contenido:** El conjunto de datos contiene una amplia gama de películas y programas de televisión con diferentes clasificaciones y géneros.

- **Calificaciones comunes:** La información sobre las calificaciones más comunes proporciona una comprensión del público objetivo del contenido.

Este análisis proporciona una visión integral del contenido de Amazon Prime y puede ayudar a informar la estrategia de contenido y la toma de decisiones.
