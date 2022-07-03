# preview authors
select * from authors 
limit 5;

# preview reviews
select * from reviews 
limit 5; 

# how many reviews were made in 2022?
select count(*) as num_reviews_2022 from reviews 
where from_unixtime(timestamp_created, '%Y') = '2022';
-- num_reviews_2022
-- 94

# how many reviews were postive or negative?
select voted_up, count(*) as review_count
from reviews 
group by voted_up;
-- voted_up, review_count
-- 0		 398
-- 1		 779

# how many reviewers own only 1 game (be it MoE or otherwise)
select count(*) as have_1_game from authors 
where num_games_owned = 1;
-- have_1_game
-- 54

# which players have played at least 1 hour in the last two weeks?
select * from authors 
where playtime_last_two_weeks >= 60;
-- First 3 lines:
-- steamid,				num_games_owned, num_reviews, playtime_forever, playtime_last_two_weeks, playtime_at_review, last_played
-- 76561197967159274	20				1			  48575				91						 46846				 1656274812
-- 76561197969435750	49				7			  833293			14409					 1899				 1656333377
-- 76561197974025369	4				1			  111384			3816					 10285				 1656331182

# how many reviewers have played at least 5 hours in the last two weeks?
select count(*) as num_players_5hrs from authors 
where playtime_last_two_weeks >= 60*5;

# what was the last date that any player had played?
select from_unixtime(last_played, '%h:%i %p %Y %M %D') as last_date_played 
from authors 
order by last_played desc 
limit 1;
-- last_date_played
-- 11:44 AM 2022 June 27th

# what were the last 5 dates that players leaving negative reviews had played?
# from_unixtime(last_played, '%h:%i %p %Y %M %D') as last_date_played_negative_review 
select distinct from_unixtime(last_played, '%Y %M %D') as last_dates_played_negative_review 
from authors
join reviews on reviews.steamid = authors.steamid
where reviews.voted_up = 0
order by last_played desc limit 5;
-- last_dates_played_negative_review
-- 2022 June 27th
-- 2022 June 26th
-- 2022 June 25th
-- 2022 June 24th
-- 2022 June 23rd

# What is the average, minimum, and maximum length of time players have spent when they leave a negative review?
select avg(playtime_at_review) as avg_time_spent,
		min(playtime_at_review) as min_time_spent,
		max(playtime_at_review) as max_time_spent
from authors
join reviews on reviews.steamid = authors.steamid
where reviews.voted_up = 0;
-- avg_time_spent, min_time_spent, max_time_spent
-- 31350.7085	   5			   770436

# What about positive reviews? 
select avg(playtime_at_review) as avg_time_spent,
		min(playtime_at_review) as min_time_spent,
		max(playtime_at_review) as max_time_spent
from authors
join reviews on reviews.steamid = authors.steamid
where reviews.voted_up = 1;
-- avg_time_spent, min_time_spent, max_time_spent
-- 22467.3171		5				869258

# What is the distribution of the reviews by language?
select language, 
	count(language) as num_reviews,
    100*count(language)/(select count(*) as sum from reviews) AS percentage
from reviews
group by language
order by num_reviews desc;
-- first 3 rows
-- language, num_reviews, percentage
-- english	 421	35.7689
-- turkish	 157	13.3390
-- russian	 124	10.5353






