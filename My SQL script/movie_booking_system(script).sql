DROP DATABASE IF EXISTS movie_ticket_booking;
CREATE DATABASE movie_ticket_booking;
USE movie_ticket_booking;

CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    duration_minutes INT,
    rating VARCHAR(10)
);

CREATE TABLE theaters (
    theater_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    capacity INT
);

CREATE TABLE showtimes (
    showtime_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT,
    theater_id INT,
    show_time DATETIME NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (theater_id) REFERENCES theaters(theater_id)
);

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    showtime_id INT,
    number_of_tickets INT NOT NULL,
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (showtime_id) REFERENCES showtimes(showtime_id)
);

INSERT INTO movies (title, genre, duration_minutes, rating) VALUES
('The Galactic Saga', 'Sci-Fi', 150, 'PG-13'),
('A Knight''s Tale', 'Fantasy', 135, 'PG'),
('City of Whispers', 'Thriller', 110, 'R'),
('Midnight Serenade', 'Romance', 105, 'PG-13'),
('The Last Detective', 'Mystery', 120, 'R');

INSERT INTO theaters (name, location, capacity) VALUES
('Grand Cinema', 'Downtown', 250),
('Starplex Screen 1', 'Suburban Mall', 150),
('Starplex Screen 2', 'Suburban Mall', 150),
('Regal 8', 'West Side', 300);

INSERT INTO showtimes (movie_id, theater_id, show_time) VALUES
(1, 1, '2025-11-20 18:00:00'),
(1, 1, '2025-11-20 21:30:00'),
(2, 2, '2025-11-21 14:00:00'),
(3, 3, '2025-11-21 19:45:00'),
(4, 4, '2025-11-22 17:00:00'),
(5, 4, '2025-11-22 20:30:00'),
(2, 2, '2025-11-22 11:00:00'),
(3, 3, '2025-11-22 22:00:00');

INSERT INTO bookings (customer_name, showtime_id, number_of_tickets) VALUES
('Alice Johnson', 1, 2),
('Bob Williams', 3, 4),
('Charlie Brown', 5, 1),
('Diana Prince', 2, 3),
('Eve Adams', 4, 2),
('Frank White', 6, 5),
('Grace Kelly', 7, 1),
('Henry Jones', 8, 2);

SHOW TABLES;

SELECT * FROM movies;
SELECT * FROM theaters;
SELECT * FROM showtimes;
SELECT * FROM bookings;

-- 1. Find the total number of tickets sold for each movie.
SELECT
    m.title,
    SUM(b.number_of_tickets) AS total_tickets_sold
FROM
    bookings b
JOIN
    showtimes s ON b.showtime_id = s.showtime_id
JOIN
    movies m ON s.movie_id = m.movie_id
GROUP BY
    m.title
ORDER BY
    total_tickets_sold DESC;
    
-- 2. Identify the most popular movie (by tickets sold) and the theater where it's playing.
SELECT
    m.title,
    t.name AS theater_name,
    SUM(b.number_of_tickets) AS total_tickets_sold
FROM
    bookings b
JOIN
    showtimes s ON b.showtime_id = s.showtime_id
JOIN
    movies m ON s.movie_id = m.movie_id
JOIN
    theaters t ON s.theater_id = t.theater_id
GROUP BY
    m.title, t.name
ORDER BY
    total_tickets_sold DESC
LIMIT 1;

-- 3. Update a movie's rating.
SELECT movie_id FROM movies WHERE title = 'The Galactic Saga';

UPDATE movies
SET rating = 'PG'
WHERE movie_id = 1;

-- 4. Delete an old showtime that has no bookings.
DELETE FROM showtimes
WHERE showtime_id = 8 AND showtime_id NOT IN (
    SELECT showtime_id FROM bookings
);

-- 5. List all movies and their showtimes for a specific date at a particular theater.
SELECT
    m.title,
    s.show_time
FROM
    showtimes s
JOIN
    movies m ON s.movie_id = m.movie_id
JOIN
    theaters t ON s.theater_id = t.theater_id
WHERE
    t.name = 'Grand Cinema'
AND
    DATE(s.show_time) = '2025-11-20';

-- 6. Find customers who have booked tickets for more than one movie.
SELECT
    b.customer_name
FROM
    bookings b
JOIN
    showtimes s ON b.showtime_id = s.showtime_id
GROUP BY
    b.customer_name
HAVING
    COUNT(DISTINCT s.movie_id) > 1;