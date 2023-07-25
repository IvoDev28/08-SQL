-- Año de Nacimiento
SELECT name, year 
FROM movies 
WHERE year=2001;

--1982
SELECT COUNT(name), year 
FROM movies 
WHERE year=1982;

--Stacktors
SELECT * 
FROM actors 
WHERE last_name 
LIKE '%stack%';

--Juego del Nombre de la Fama
SELECT first_name, COUNT(first_name) as 'nombresPopulares' 
FROM actors 
GROUP BY first_name 
ORDER BY nombresPopulares desc 
LIMIT 10; 

SELECT last_name, COUNT(last_name) as 'apellidosPopulares' 
FROM actors 
GROUP BY last_name 
ORDER BY apellidosPopulares desc 
LIMIT 10;

SELECT first_name || ' ' || last_name as nombres_completos, COUNT(*) 
FROM actors 
GROUP BY nombres_completos 
ORDER BY COUNT(*) desc 
LIMIT 10;

--Prolífico
SELECT first_name, last_name, COUNT(role)
FROM actors
INNER JOIN roles ON actors.id = roles.actor_id
GROUP BY first_name, last_name
ORDER BY COUNT(role) desc
LIMIT 100; 

--Fondo de Barril
SELECT genre , COUNT(movies_genres.movie_id) as 'contador' 
FROM movies_genres 
INNER JOIN movies ON movies_genres.movie_id = movies.id 
GROUP BY genre 
ORDER BY contador asc;

-- Braveheart
SELECT first_name, last_name 
FROM roles
INNER JOIN actors ON roles.actor_id = actors.id 
WHERE movie_id = 46169
ORDER BY last_name asc;

--Noir Bisiesto
SELECT directors.first_name, directors.last_name, name, year
FROM movies
INNER JOIN movies_genres ON movies.id = movies_genres.movie_id
INNER JOIN movies_directors ON movies_genres.movie_id = movies_directors.movie_id
INNER JOIN directors ON movies_directors.director_id = directors.id
WHERE year % 4 = 0 AND movies_genres.genre = 'Film-Noir';

-- Kevin Bacon
SELECT nombre_pelicula, actors.first_name, actors.last_name
FROM (
SELECT movies.name as 'nombre_pelicula', actors.first_name as 'nombre', actors.last_name as 'apellido', movies.id as 'id_pelicula'
FROM roles
INNER JOIN actors ON roles.actor_id = actors.id AND nombre = 'Kevin' AND apellido = 'Bacon' 
INNER JOIN movies ON roles.movie_id = movies.id
INNER JOIN movies_genres ON movies.id = movies_genres.movie_id AND movies_genres.genre = 'Drama'
) as 'tabla_kevin'
INNER JOIN roles ON tabla_kevin.id_pelicula = roles.movie_id
INNER JOIN actors ON roles.actor_id = actors.id AND NOT actors.first_name = 'Kevin' AND actors.last_name = 'Bacon'
LIMIT 100;

-- Actores Inmortales
SELECT first_name, last_name, id
FROM actors
WHERE id IN(
  SELECT actor_id
  FROM roles 
  WHERE movie_id IN(
  SELECT id
  FROM movies
  WHERE year < 1900
)
)
INTERSECT
SELECT first_name, last_name, id
FROM actors
WHERE id IN(
  SELECT actor_id
  FROM roles 
  WHERE movie_id IN(
  SELECT id
  FROM movies
  WHERE year > 2000
)
)
ORDER BY id;

