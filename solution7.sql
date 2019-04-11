--1.List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962

--2.Give year of 'Citizen Kane'.
SELECT yr
 FROM movie
 WHERE title='Citizen Kane'
 
--3.List all of the Star Trek movies, include the id, title and yr
--(all of these movies include the words Star Trek in the title). Order results by year.
SELECT id ,title,yr
 FROM movie
 WHERE title like '%Star Trek%'
 order by yr
 
--4.What id number does the actor 'Glenn Close' have?
SELECT id 
 FROM actor
 WHERE name= 'Glenn Close'
 
--5.What is the id of the film 'Casablanca'
SELECT id 
 FROM movie
 WHERE title= 'Casablanca'
 
--6.Obtain the cast list for 'Casablanca'.
--Use movieid=11768, (or whatever value you got from the previous question)
SELECT name
 FROM casting c join actor a
  on a.id=c.actorid
 WHERE c.movieid=11768
 
 --7.Obtain the cast list for the film 'Alien'
 SELECT name
 FROM casting  join actor a
  on a.id=casting.actorid
               join movie m
  on m.id=casting.movieid
      
 WHERE m.title='Alien'
 
 --8.List the films in which 'Harrison Ford' has appeared
 SELECT title
 FROM casting  join actor a
  on a.id=casting.actorid
               join movie m
  on m.id=casting.movieid
      
 WHERE a.name='Harrison Ford'
 
 --9.List the films where 'Harrison Ford' has appeared - but not in the starring role. 
 --[Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
 SELECT title
 FROM casting  join actor a
  on a.id=casting.actorid
               join movie m
  on m.id=casting.movieid
      
 WHERE a.name='Harrison Ford'
  and casting.ord!=1
  
  --10.List the films together with the leading star for all 1962 films.
  SELECT distinct title,name
 FROM casting  join actor a
  on a.id=casting.actorid
               join movie m
  on m.id=casting.movieid
      
 WHERE m.yr = 1962 and ord=1
 
 --11.Which were the busiest years for 'John Travolta', 
 --show the year and the number of movies he made each year for any year in which he made more than 2 movies.
 
select * from (
 SELECT yr,COUNT(title) c FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
) t
where c>2

--12.List the film title and the leading actor for all of the films 'Julie Andrews' played in.
--get "Little Miss Marker twice"? solution
select distinct title,name
   from casting  join actor a
  on a.id=casting.actorid
               join movie m
  on m.id=casting.movieid
  
  where title in (SELECT distinct title
 FROM casting  join actor a
  on a.id=casting.actorid
               join movie m
  on m.id=casting.movieid
      
 WHERE a.name='Julie Andrews')
        and casting.ord=1

--pass solution (from online)
SELECT DISTINCT m.title, a.name
FROM (SELECT movie.*
      FROM movie
      JOIN casting
      ON casting.movieid = movie.id
      JOIN actor
      ON actor.id = casting.actorid
      WHERE actor.name = 'Julie Andrews') AS m
JOIN (SELECT actor.*, casting.movieid AS movieid
      FROM actor
      JOIN casting
      ON casting.actorid = actor.id
      WHERE casting.ord = 1) as a
ON m.id = a.movieid
ORDER BY m.title;

--13.Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
SELECT actor.name
FROM actor
JOIN casting
ON casting.actorid = actor.id
WHERE casting.ord = 1
GROUP BY actor.name
HAVING COUNT(1) >= 30;


--14.List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title,count(1) c
 FROM casting  join actor a
  on a.id=casting.actorid
               join movie m
  on m.id=casting.movieid
      
 WHERE m.yr = 1978 
  group by title
  order by c desc,title
