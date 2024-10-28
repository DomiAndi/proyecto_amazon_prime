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
