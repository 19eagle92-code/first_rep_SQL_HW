CREATE TABLE IF NOT EXISTS genre (
  genre_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS singer (
  singer_id SERIAL PRIMARY KEY,
  name VARCHAR(60) NOT NULL
);

CREATE TABLE IF NOT EXISTS album (
  album_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  year SMALLINT CHECK (year >= 1900 AND year <= EXTRACT(YEAR FROM CURRENT_DATE))
);

CREATE TABLE IF NOT EXISTS track (
  track_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  duration TIME NOT NULL,
  album_id INT NOT NULL,
  CONSTRAINT fk_track_album FOREIGN KEY (album_id) REFERENCES album(album_id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS collection (
  collection_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  year SMALLINT CHECK (year >= 1900 AND year <= EXTRACT(YEAR FROM CURRENT_DATE))
);

CREATE TABLE IF NOT EXISTS singer_genre (
  singer_genre_id SERIAL PRIMARY KEY,
  singer_id INT NOT NULL REFERENCES singer(singer_id) ON DELETE CASCADE,
  genre_id INT NOT NULL REFERENCES genre(genre_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS singer_album (
  singer_album_id SERIAL PRIMARY KEY,
  singer_id INT NOT NULL REFERENCES singer(singer_id) ON DELETE CASCADE,
  album_id INT NOT NULL REFERENCES album(album_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS collection_track (
  collection_track_id SERIAL PRIMARY KEY,
  collection_id INT NOT NULL REFERENCES collection(collection_id) ON DELETE CASCADE,
  track_id INT NOT NULL REFERENCES track(track_id) ON DELETE CASCADE
  );

ALTER TABLE collection_track DROP CONSTRAINT collection_track_collection_id_fkey;

ALTER TABLE collection_track ALTER COLUMN collection_id DROP NOT NULL;

ALTER TABLE collection_track 
ADD CONSTRAINT collection_track_collection_id_fkey 
FOREIGN KEY (collection_id) REFERENCES collection(collection_id) ON DELETE CASCADE;

--удаляем таблицу и сбрасываем счетчик, попутно находим имя последовательности сдля сброса счетчика
DELETE FROM genre;
SELECT 
    pg_get_serial_sequence('genre', 'genre_id') as sequence_name;
ALTER SEQUENCE public.genre_genre_id_seq RESTART WITH 1;

DELETE FROM singer;
SELECT 
    pg_get_serial_sequence('singer', 'singer_id') as sequence_name;
ALTER SEQUENCE public.singer_singer_id_seq RESTART WITH 1;

DELETE FROM album;
ALTER SEQUENCE public.album_album_id_seq RESTART WITH 1;

DELETE FROM track;
ALTER SEQUENCE public.track_track_id_seq RESTART WITH 1;

DELETE FROM collection;
ALTER SEQUENCE public.collection_collection_id_seq RESTART WITH 1;

DELETE FROM singer_genre;
ALTER SEQUENCE public.singer_genre_singer_genre_id_seq RESTART WITH 1;

DELETE FROM singer_album;
ALTER SEQUENCE public.singer_album_singer_album_id_seq RESTART WITH 1;

DELETE FROM collection_track;
ALTER SEQUENCE public.collection_track_collection_track_id_seq RESTART WITH 1;
























































