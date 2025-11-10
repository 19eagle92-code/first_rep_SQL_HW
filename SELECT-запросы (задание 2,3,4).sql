--Задание 2
--2.1.Название и продолжительность самого длительного трека
SELECT  title, duration FROM track
ORDER BY duration DESC 
LIMIT 1;

-- или (для треков > 1 с одинаковой max длительностью)
SELECT title, duration FROM track 
WHERE duration = (SELECT MAX(duration) FROM track);

--2.2.Название треков, продолжительность которых не менее 3,5 минут.
SELECT title, duration FROM track
WHERE duration>= '00:03:30';

--2.3.Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT title, year FROM collection 
WHERE year BETWEEN '2018' AND '2020' ;
--ORDER BY year;

--2.4.Исполнители, чьё имя состоит из одного слова.
SELECT name FROM singer 
WHERE name NOT LIKE '% %';

--2.5.Название треков, которые содержат слово «мой» или «my».
SELECT  title FROM track
WHERE title ILIKE '%мой%' OR title ILIKE  '%my%';


--Задание 3
--3.1.Количество исполнителей в каждом жанре.
SELECT g.title AS жанр, COUNT(sg.singer_id) AS количество_исполнителей
FROM genre g
LEFT JOIN singer_genre sg ON g.genre_id = sg.genre_id
GROUP BY g.genre_id
ORDER BY количество_исполнителей DESC;

--3.2.Количество треков, вошедших в альбомы 2019–2020(1979-1997) годов.
SELECT COUNT(t.title) AS Количество_треков 
FROM track t 
LEFT JOIN album a ON t.album_id  = a.album_id 
WHERE year BETWEEN '1979' AND '1997';
 
--3.3.Средняя продолжительность треков по каждому альбому.
SELECT a.title AS альбом, AVG(t.duration) AS Средняя_продолжительность
FROM track t
LEFT JOIN album a ON t.album_id  = a.album_id
GROUP BY a.title ;

--3.4.Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT DISTINCT s.name 
FROM singer s 
WHERE s.singer_id NOT IN (
    SELECT sa.singer_id 
    FROM singer_album sa 
    JOIN album a ON sa.album_id = a.album_id 
    WHERE a.year = 2020
);

--3.5.Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами = КиШ).
-- через подзапросы
SELECT c.title 
FROM collection c  
WHERE c.collection_id IN (
    SELECT ct.collection_id  
    FROM collection_track ct  
    WHERE ct.track_id IN (
        SELECT t.track_id
        FROM track t
        WHERE t.album_id IN (
            SELECT sa.album_id
            FROM singer_album sa
            WHERE sa.singer_id IN (
                SELECT s.singer_id
                FROM singer s
                WHERE s.name = 'КиШ'
            )
        )
    )
);

-- через последовательное соединение таблиц
SELECT DISTINCT c.title 
FROM collection c  
JOIN collection_track ct ON c.collection_id = ct.collection_id
JOIN track t ON ct.track_id = t.track_id
JOIN album a ON t.album_id = a.album_id
JOIN singer_album sa ON a.album_id = sa.album_id
JOIN singer s ON sa.singer_id = s.singer_id
WHERE s.name = 'КиШ';


--Задание 4(необязательное)
--4.1.Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
SELECT  a.title AS названия_альбомов
FROM album a 
JOIN singer_album sa ON a.album_id  = sa.album_id   
JOIN singer s  ON sa.singer_id  = s.singer_id 
JOIN singer_genre sg  ON s.singer_id = sg.singer_id 
JOIN genre g ON sg.genre_id = g.genre_id 
GROUP BY a.album_id, a.title, s.singer_id, s.name 
HAVING COUNT(DISTINCT sg.genre_id) > 1;

--4.2.Наименования треков, которые не входят в сборники.
SELECT t.title
FROM track t
LEFT JOIN collection_track ct  ON ct.track_id  = t.track_id 
LEFT JOIN collection c ON c.collection_id = ct.collection_id
WHERE ct.collection_id IS NULL;

--4.3.Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
SELECT s.name AS исполнитель, t.duration AS длительность 
FROM singer s 
JOIN singer_album sa ON sa.singer_id = s.singer_id 
JOIN album a ON a.album_id = sa.album_id 
JOIN track t ON sa.album_id = t.album_id
WHERE duration = (SELECT MIN(duration) FROM track);

--4.4.Названия альбомов, содержащих наименьшее количество треков
WITH counts AS (
    SELECT a.title AS название_альбома, COUNT(t.title ) AS количество_треков
    FROM album a
    JOIN track t ON t.album_id = a.album_id
    GROUP BY a.title
)
SELECT название_альбома, количество_треков
FROM counts
WHERE количество_треков = (SELECT MIN(количество_треков) FROM counts);




