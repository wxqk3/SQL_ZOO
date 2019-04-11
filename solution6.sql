--1.Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'
SELECT matchid,player FROM goal 
  WHERE teamid = 'GER'
  
--2.From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.
--Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.
--Show id, stadium, team1, team2 for just game 1012
select id, stadium, team1, team2 from game
 where id='1012'

--3.Modify it to show the player, teamid, stadium and mdate for every German goal.
SELECT player,teamid,stadium,mdate
  FROM game JOIN goal ON (id=matchid)
     WHERE teamid = 'GER'
     
--4.Use the same JOIN as in the previous question.
--Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1,team2,player
  FROM game JOIN goal ON (id=matchid)
     WHERE player LIKE 'Mario%'

--5.Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
  FROM goal join eteam
   on teamid=id
 WHERE gtime<=10
 
--6.List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
select mdate,teamname
   from game g join eteam e
  where team1=e.id and coach = 'Fernando Santos'
  
--7.List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
select player
   from game g join goal e
  on g.id=e.matchid 
where stadium = 'National Stadium, Warsaw'

--8. The example query shows all goals scored in the Germany-Greece quarterfinal.
--Instead show the name of all players who scored a goal against Germany.
SELECT distinct player
  FROM game JOIN goal ON matchid = id 
    WHERE (team1='GER' or team2='GER')
   and teamid!='GER'

--9.Show teamname and the total number of goals scored.
SELECT teamname, count(player)
  FROM eteam JOIN goal ON id=teamid
 group BY teamname
 
 --10.Show the stadium and the number of goals scored in each stadium.
 SELECT stadium, count(player)
  FROM goal JOIN game ON id=matchid
 group BY stadium
 
 --11.For every match involving 'POL', show the matchid, date and the number of goals scored.
 SELECT matchid, mdate, COUNT(player) goals_scored
FROM game
JOIN goal ON goal.matchid = game.id
WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY goal.matchid,mdate

--12.For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid, mdate, COUNT(player) goals_scored
FROM game
JOIN goal ON goal.matchid = game.id
WHERE teamid='GER'
GROUP BY goal.matchid,mdate

--13.Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. 
--You could SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2.
SELECT mdate, team1,

SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END)  score1,

team2, SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END)  score2

FROM game JOIN goal ON id = matchid

GROUP BY id,mdate,team1,team2

ORDER BY mdate, matchid, team1, team2
