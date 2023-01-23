
SHOW DATABASES;
USE ig_clone;
 

	SHOW TABLES;
	SELECT * FROM 



## Task: Find the 5 oldest users of the Instagram from the database provided 

SELECT * 
FROM users
ORDER BY created_at
LIMIT 5 

## Task: Find the users who have never posted a single photo on Instagram 

SELECT username
FROM users
LEFT JOIN photos
	ON users.id=photos.user_id
WHERE photos.id IS NULL;

## Task: Identify the winner of the contest and provide their details to the team

SELECT 
    username,
	photos.id,
    photos.image_url, 
    count(likes.user_id) AS total
FROM photos
INNER JOIN likes 
    ON likes.photo_id=photos.id
INNER JOIN users
    ON photos.user_id = users.id
GROUP BY photos.id 
ORDER BY total DESC
LIMIT 1

## Task: Identify and suggest the top 5 most commonly used hashtags on the platform

SELECT 
( Select COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS avg;

## Task: What day of the week do most users register on? Provide insights on when to schedule an ad campaign

SELECT date_format(created_at,'%W') AS 'day of the week', COUNT(*) AS 'total registration'
FROM users
GROUP BY 1
ORDER BY 2 DESC;

## User Engagement: Task: Provide how many times does average user posts on Instagram. Also, provide the total number of photos on Instagram/total number of users

select (select count(*) FROM ig_clone.photos) / (select count(*) FROM ig_clone.users) AS User_Engagement

## Bots & Fake Accounts : Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this)

SELECT users.id,username, COUNT(users.id) As total_likes_by_user
FROM users
JOIN likes ON users.id = likes.user_id
GROUP BY users.id
HAVING total_likes_by_user = (SELECT COUNT(*) FROM photos);
