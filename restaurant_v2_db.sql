CREATE TABLE restaurant (
  id serial PRIMARY KEY,
  name varchar,
  address varchar,
  category varchar
);

CREATE TABLE review (
  id serial PRIMARY KEY,
  author_reviewer_id integer REFERENCES reviewer (id),
  stars integer CHECK (stars >= 0 and stars <= 5),
  title varchar,
  review varchar,
  restaurant_id integer REFERENCES restaurant (id)
);

CREATE TABLE reviewer (
  id serial PRIMARY KEY,
  name varchar,
  email varchar,
  karma integer CHECK (karma >= 0 and karma <= 7)
);

insert into restaurant values
  (default, 'Bistro du Midi', '272 Bolyston St Boston, MA 02116', 'French');

insert into restaurant values
  (default, 'Liquid Art House', '100 Arlington St Boston, MA 02116', 'Sandwiches, Desserts, Cafes'),
  (default, 'The Parish Cafe', '361 Bolyston St Boston, MA 02116', 'French'),
  (default, 'Red Lantern', '39 Stanhope St Boston, MA 02116', 'Asian Fusion'),
  (default, 'Eastern Standard Kitchen and Drinks', '528 Commonwealth Ave Boston, MA 02215', 'American'),
  (default, 'Shojo', '9A Tyler St Boston, MA 02111', 'Asian Fusion, Japanese, Tapas Bar');

insert into review values
  (default, 1, 4, 'Galloping Gargolyes', 'Such fun! Wear red to ward off vampires!', 4);

insert into review values
  (default, 1, 5, 'Get Your Glamour On', 'The glamour on the food makes it oh so tasty!', 6),
  (default, 2, 3, 'For the owl in you', 'For those who wear night goggles! No butter beer.', 1),
  (default, 3, 2, 'Muggles like this?', 'What food?! Just artwork everywhere; they blended with the food.', 2),
  (default, 4, 1, 'Nightlife Overload', 'Want some glitter in your food? Then you''re in the right place.', 5);

insert into review values
  (default, 3, 5, 'Winding staircases..', 'Seafood galore!! I like.', 1);

insert into reviewer values
  (default, 'Luna Lovegood', 'looneyGal@gmail.com', 6),
  (default, 'Harry Potter', 'theChosenOne@gmail.com', 4),
  (default, 'Ronald Weasley', 'mr.freckles@gmail.com', 2),
  (default, 'Hermione Granger', 'cleverWitch@gmail.com', 7);

-- list the reviews for a given restaurant (filter by its name or id)
select * from review where restaurant_id = 4;

-- list the reviews for a given reviewer (filter by his/her name or id)
select * from review where author_reviewer_id = 4;

-- 1. list each review along with the restaurant they were written for. Select just the restaurant name and the review text
(regular)
select
  *
from
  review, restaurant
where
  review.restaurant_id = restaurant.id and restaurant.name = 'Bistro du Midi';
(inner) select * from review inner join restaurant on review.restaurant_id = restaurant.id where restaurant.name = 'Bistro du Midi';
(right outer) select review, restaurant.name from review right outer join restaurant on restaurant_id = restaurant.id; GOOD
(left outer) select name, review.review from restaurant left outer join review on restaurant.id = review.restaurant_id; GOOD

-- 2. get the average stars by restaurant. (restaurant name, average star rating)
(inner) select avg(stars) from review inner join restaurant on review.restaurant_id = restaurant.id;

-- 3. select name, review.avg(stars) from restaurant left outer join review on restaurant.id = review.restaurant_id;
select name, avg(stars) from restaurant left outer join review on restaurant.id = review.restaurant_id group by restaurant.id;
select avg(stars), restaurant.name from review right outer join restaurant on restaurant_id = restaurant.id group by restaurant.id;
select avg(stars), restaurant.name from review inner join restaurant on review.restaurant_id = restaurant.id group by restaurant.id;

-- 4. select name from restaurant, review where restaurant.id = review.restaurant_id order by avg(stars);
select avg(stars) as stars, restaurant.name from review inner join restaurant on review.restaurant_id = restaurant.id group by restaurant.id order by stars desc;

-- 5. get the number of reviews written for each restaurant. Select the restaurant name and the review count.
select count(review), restaurant.name from review inner join restaurant on review.restaurant_id = restaurant.id group by restaurant.id;

-- 6. list each review along with the restaurant, and the reviewer's name. Select the restaurant name,
-- the review text, and the reviewer name
select restaurant.name, review.review, reviewer.name from restaurant, review, reviewer where restaurant.id = review.restaurant_id and review.author_reviewer_id = reviewer.id;

-- 7. get the average stars by reviewer (reviewer name, average star rating)
select avg(stars) as stars, reviewer.name from review inner join reviewer on review.author_reviewer_id = reviewer.id group by reviewer.id order by stars desc;

-- 8. get the lowest star rating for each reviewer (reviewer name, lowest star rating)
select min(star) as stars, reviewer.name from review inner join reviewer on review.author_reviewer_id = reviewer.id group by reviewer.id;

-- 9. get the number of restaurants in each category (category name, restaurant count)
select count(restaurant), category from restaurant group by category;

-- 10. get number of 5 star reviews by restaurant (restaurant name, 5-star count)
select count(stars), restaurant.name from review inner join restaurant on review.restaurant_id = restaurant.id and stars = 5 group by restaurant.id;

-- 11. average star rating for a food category (category name, average star rating)
select count(stars), restaurant.name from review inner join restaurant on review.restaurant_id = restaurant.id and stars = 5 group by restaurant.id;




-- select name, review.stars from restaurant left outer join review on restaurant.id = review.restaurant_id;
-- select stars, restaurant.name from review right outer join restaurant on restaurant_id = restaurant.id;
-- select * from review, restaurant where review.restaurant_id = restaurant.id and restaurant.name = 'Bistro du Midi';
-- select * from review inner join restaurant on review.restaurant_id = restaurant.id where restaurant.name = 'Bistro du Midi';
-- select avg(stars), restaurant.name from review inner join restaurant on review.restaurant_id = restaurant.id order by name ;
