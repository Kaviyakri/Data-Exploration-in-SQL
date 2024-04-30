select * from trips;

select * from trips_details4;

select * from loc;

select * from duration;

select * from payment;
--total trips

select count(distinct tripid) from trips_details4;


--total drivers

select * from trips;

select count(distinct driverid) from trips;

-- total earnings

select sum(fare) from trips;

-- total Completed trips

select * from trips_details4;
select sum(end_ride) from trips_details4;

--total searches
select sum(searches),sum(searches_got_estimate),sum(searches_for_quotes),sum(searches_got_quotes),
sum(customer_not_cancelled),sum(driver_not_cancelled),sum(otp_entered),sum(end_ride)
from trips_details4;


select * from trips;
select avg(fare) from trips;
select avg(distance) from trips;
-- most payment method used
SELECT a.method
FROM payment a
INNER JOIN (
  SELECT faremethod, COUNT(DISTINCT tripid) AS cnt
  FROM trips
  GROUP BY faremethod
  ORDER BY cnt DESC
  LIMIT 1
) b ON a.id = b.faremethod
-- the highest payment was made through which instrument
select a.method from payment a inner join
(select  * from trips
order by fare desc
limit 1) b
on a.id= b.faremethod;

select faremethod,sum(fare) from trips
group by faremethod
order by sum(fare) desc
limit 1;

-- which two locatiion had most trips
SELECT *
FROM (
  SELECT loc_from, loc_to, count(distinct tripid) AS trip,
         DENSE_RANK() OVER (ORDER BY count(distinct tripid) DESC) AS rnk
  FROM trips
  GROUP BY loc_from, loc_to
) a
WHERE rnk = 1;

-- top 5 earing drivers
select * from
(select*,dense_rank() over(order by fare desc) rnk
from
(select driverid,sum(fare) fare from trips
group by driverid)b)c
where rnk<6;
-- which duration had more trips
select * from
 (select*,rank() over(order by cnt desc) rnk from
 (select duration,count(distinct tripid) cnt from trips
 group by duration)b)c
 where rnk =1;
 
 -- which driver,customer pair had more orders
 select*from
 (select*,rank() over(order by cnt desc) rnk from
 (select driverid,custid,count(distinct tripid) cnt from trips
 group by driverid,custid)c)d
 where rnk=1;
 -- search to estimate rate
 select sum(searches_got_estimate)*100.0/sum(searches) from trips_details4;
 
 -- which area got highest trips in which duration
 
 select * from
  (select *,rank() over(partition by duration order by cnt desc ) rnk from
  (select duration,loc_from,count(distinct tripid) cnt from trips
  group by duration,loc_from)a)c
  where rnk = 1;
  
  select * from
  (select *,rank() over(partition by loc_from order by cnt desc ) rnk from
  (select duration,loc_from,count(distinct tripid) cnt from trips
  group by duration,loc_from)a)c
  where rnk = 1;
  
  -- which area got the highest fares,cancellation,trips,
  
  select loc_from,(sum(fare)) from trips
  group by loc_from
  order by sum(fare) desc;
  -- another method
  select * from (select*,rank() over(order by fare desc) rnk
  from
  (select loc_from,sum(fare) fare from trips
  group by loc_from)b)c
  where rnk=1;
  
  select * from (select*,rank() over(order by can desc) rnk
  from
  (
  select loc_from,count(*)-sum(driver_not_cancelled) can
  from trips_details4
  group by loc_from)b)c
  where rnk =1;
  -- highest customer cancellation 
    select * from (select*,rank() over(order by can desc) rnk
  from
  (
  select loc_from,count(*)-sum(customer_not_cancelled) can
  from trips_details4
  group by loc_from)b)c
  where rnk =1;
  
  -- which duration got the highest trips and fares
  select * from (select *,rank() over(order by fare desc) rnk
  from
  (select duration,sum(fare) fare from trips
  group by duration)b)c
  where rnk=1;
  
  select * from (select *,rank() over(order by fare desc) rnk
  from
  (select duration,count(distinct tripid) fare from trips
  group by duration)b)c
  where rnk=1;