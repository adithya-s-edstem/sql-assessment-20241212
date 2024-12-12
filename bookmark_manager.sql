-- Database: bookmark_manager

-- DROP TABLE IF EXISTS
-- 	bookmarks,
-- 	users,
-- 	collections,
-- 	tags,
-- 	bookmark_tags,
-- 	shares;

-- Create Tables

CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
	user_email VARCHAR(30) NOT NULL UNIQUE,
	user_name VARCHAR(30) NOT NULL
);

CREATE TABLE collections (
	collection_id SERIAL PRIMARY KEY,
	collection_name VARCHAR(30) NOT NULL UNIQUE,
	owner_id INT references users(user_id) NOT NULL
);

CREATE TABLE bookmarks (
	bookmark_id SERIAL PRIMARY KEY,
	collection_id INT references collections(collection_id),
	bookmark_title VARCHAR(30) NOT NULL,
	bookmark_url VARCHAR(100) NOT NULL UNIQUE,
	bookmark_owner_id INT references users(user_id),
	bookmark_date DATE NOT NULL
);

CREATE TABLE tags (
	tag_id SERIAL PRIMARY KEY,
	tag_name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE bookmark_tags (
	bookmark_tag_id SERIAL PRIMARY KEY,
	bookmark_id INT references bookmarks(bookmark_id) NOT NULL,
	tag_id INT references tags(tag_id) NOT NULL
);

CREATE TABLE shares (
	share_id SERIAL PRIMARY KEY,
	collection_id INT references collections(collection_id) NOT NULL,
	shared_with_user_id INT references users(user_id) NOT NULL,
	share_date date NOT NULL
);

-- Insert values

INSERT INTO users values
	(DEFAULT, 'adithya.s@edstem.com', 'Adithya S Sekhar'),
	(DEFAULT, 'akhiljith.s@edstem.com', 'Akhiljith S'),
	(DEFAULT, 'aswanth.k@edstem.com', 'Aswanth K');

INSERT INTO tags values
	(DEFAULT, 'Frontend'),
	(DEFAULT, 'Backend'),
 	(DEFAULT, 'Funny'),
	(DEFAULT, 'Fullstack');

INSERT INTO collections values
  	(DEFAULT, 'Development Resources', 1),
  	(DEFAULT, 'Funny pictures', 2);

INSERT INTO bookmarks values
  	(DEFAULT, 1, 'React Documentation', 'https://react.com', 1, '2024-12-12'),
  	(DEFAULT, 1, 'Java Documentation', 'https://java.com', 3, '2024-12-12'),
  	(DEFAULT, 1, 'NextJS Documentation', 'https://nextjs.com', 1, '2024-12-12'),
  	(DEFAULT, 1, 'DotNet Documentation', 'https://dotnet.microsoft.com', 3, '2024-12-12'),
  	(DEFAULT, 2, 'Funny Pictures', 'https://funnypictures.com', 1, '2024-10-01');

INSERT INTO bookmark_tags values
	(DEFAULT, 1, 1),
	(DEFAULT, 2, 2),
  	(DEFAULT, 3, 1),
  	(DEFAULT, 4, 2),
	(DEFAULT, 5, 3);

INSERT INTO shares values
	(DEFAULT, 1, 2, '2024-12-12'),
	(DEFAULT, 1, 3, '2024-12-12'),
	(DEFAULT, 2, 1, '2024-10-01'),
	(DEFAULT, 2, 3, '2024-10-01');

-- Question 1

SELECT b.bookmark_title,
	b.bookmark_url,
	t.tag_name
FROM bookmarks b
INNER JOIN collections c
	ON c.collection_id = b.collection_id
INNER JOIN bookmark_tags bt
	ON bt.bookmark_id = b.bookmark_id
INNER JOIN tags t
	ON t.tag_id = bt.tag_id
WHERE c.collection_name = 'Development Resources';

-- Question 2

SELECT t.tag_name, COUNT(t.tag_id)
FROM tags t
INNER JOIN bookmark_tags bt
	ON bt.tag_id = t.tag_id
GROUP BY t.tag_name
ORDER BY COUNT(t.tag_id) DESC
LIMIT 10;

-- Question 3

SELECT
	c.collection_name,
	u.user_email,
	COUNT(DISTINCT b.bookmark_id)
FROM collections c
INNER JOIN users u
	ON c.owner_id = u.user_id
INNER JOIN bookmarks b
	ON b.collection_id = c.collection_id
INNER JOIN shares s
	ON s.collection_id = c.collection_id
GROUP BY c.collection_name, u.user_email;

-- Question 4

SELECT u.user_name
FROM users u
INNER JOIN bookmarks b
	ON b.bookmark_owner_id = u.user_id
LEFT JOIN shares s
	ON s.shared_with_user_id = u.user_id
WHERE s.share_date > current_date - interval '30 days'
OR b.bookmark_date > current_date - interval '30 days'
GROUP BY u.user_name
	