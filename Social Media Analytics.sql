create database social_media

select * from followers

select * from users

select * from likes

select * from posts

select p.post_id, user

alter table users 

ALTER TABLE comments RENAME column ï»¿comment_id TO comment_id 

-- 1. Retrieve all posts made by a specific user.

select * from posts where user_id = 2


-- 2. Count the total number of comments for a particular post.

select count(*) as total_comments from comments where post_id = 3

-- 3. List all users who liked a specific post.

select * from likes



SELECT u.username FROM Users u
JOIN Likes l ON u.user_id = l.user_id
WHERE l.post_id = 5;

-- 4. Retrieve the most recent post made by a user.

select * from users

select * from posts

select  *  from posts where user_id = 2 order by post_date desc limit 1

-- 5. Find the total number of likes received by a specific post.


select count(*) from likes where post_id = 2


-- 6. Get the usernames of users who have commented on a specific post
select * from comments
select * from users
select * from posts
select u.username from users u join comments c  on u.user_id = c.user_id where post_id = 2


-- 7. Retrieve posts made by users followed by a specific user.

select * from followers

SELECT p.* FROM Posts p
JOIN Users u ON p.user_id = u.user_id
JOIN Followers f ON u.user_id = f.following_user_id
WHERE f.follower_user_id = 2;

-- 8. List all users who have not made any posts.
select * from posts

select * from users where user_id not in (select distinct(user_id) from posts)

-- 9. Count the number of likes given by a specific user.

select count(*) from likes where user_id = 2


-- 10. Retrieve posts with more than 10 comments.


select * from posts where post_id in (select post_id from comments group by post_id having count(*)> 3)

-- 11. Find the user who has the highest number of followers

select u.username, u.user_id, count(f.follower_id) as follower_count 
from users u left join followers f on u.user_id = f.following_user_id 
group by u.user_id, u.username order by follower_count desc limit 1

-- 12. Retrieve users who have liked all posts made by a specific user

SELECT u.username FROM Users u
WHERE NOT EXISTS (
    SELECT * FROM Posts p
    WHERE NOT EXISTS (
        SELECT * FROM Likes l
        WHERE l.user_id = u.user_id AND l.post_id = p.post_id
    )
);

-- 13. Get the user who has the highest total number of likes on their posts.
select * from likes
select * from posts
select u.user_id, u.username, count(l.like_id) as ttl_like from users u join likes l on u.user_id = l.user_id 
 group by u.user_id, u.username order by ttl_like desc limit 1

-- 14. Find users who have not received any likes on their posts.

select u.user_id, u.username from users u left join posts p on u.user_id = p.user_id 
left join likes l on p.post_id = l.post_id where l.like_id is null

-- 15. Retrieve posts that have more comments than likes

SELECT * FROM Posts
WHERE (SELECT COUNT(*) FROM Comments WHERE Comments.post_id = Posts.post_id)
      > (SELECT COUNT(*) FROM Likes WHERE Likes.post_id = Posts.post_id);
 

-- 16. Retrieve the usernames of users who have liked their own posts.

select u.username from users u join posts p on u.user_id = p.user_id 
join likes l on p.post_id = l.post_id where u.user_id = l.user_id

-- 17. List users who have commented on posts made by users they are not following.

SELECT DISTINCT u.username
FROM Users u
JOIN Comments c ON u.user_id = c.user_id
JOIN Posts p ON c.post_id = p.post_id
LEFT JOIN Followers f ON u.user_id = f.following_user_id
WHERE f.follower_user_id IS NULL;


-- 18. Find posts that have more likes than the average number of likes for all posts:
SELECT p.*
FROM Posts p
JOIN (
    SELECT post_id, COUNT(*) AS likes_count
    FROM Likes
    GROUP BY post_id
) l ON p.post_id = l.post_id
WHERE l.likes_count > (
    SELECT AVG(likes_count)
    FROM (
        SELECT post_id, COUNT(*) AS likes_count
        FROM Likes
        GROUP BY post_id
    ) AS avg_likes
);

-- 19. Retrieve users who have made at least 2 comments on the same post


SELECT DISTINCT u.username
FROM Users u
JOIN Comments c1 ON u.user_id = c1.user_id
JOIN Comments c2 ON c1.post_id = c2.post_id AND c1.comment_id <> c2.comment_id
WHERE c1.post_id = c2.post_id;

-- 20. List users who have liked posts made by users they are following
SELECT DISTINCT u.username
FROM Users u
JOIN Likes l ON u.user_id = l.user_id
JOIN Posts p ON l.post_id = p.post_id
JOIN Followers f ON u.user_id = f.following_user_id
WHERE l.user_id = f.follower_user_id;

-- 21. Find users who have liked every post made by a specific user:
SELECT DISTINCT u.username
FROM Users u
JOIN Posts p ON u.user_id = p.user_id
LEFT JOIN Likes l ON p.post_id = l.post_id
WHERE NOT EXISTS (
    SELECT p2.post_id
    FROM Posts p2
    WHERE p2.user_id = 2
    AND p2.post_id NOT IN (SELECT l2.post_id FROM Likes l2 WHERE l2.user_id = u.user_id)
);

-- 22. Retrieve posts with the highest number of comments for each user:
SELECT *
FROM (
    SELECT p.*, ROW_NUMBER() OVER(PARTITION BY p.user_id ORDER BY COUNT(c.comment_id) DESC) AS rn
    FROM Posts p
    JOIN Comments c ON p.post_id = c.post_id
    GROUP BY p.post_id, p.user_id
) AS ranked_posts
WHERE rn = 1;


-- Find users who have not liked any posts:
SELECT u.username
FROM Users u
LEFT JOIN Likes l ON u.user_id = l.user_id
WHERE l.like_id IS NULL;





