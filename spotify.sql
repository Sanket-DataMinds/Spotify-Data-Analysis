-- Advance Sql Project Spotify Dataset

CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

select * from spotify;

-- EDA

select count(*) from spotify;

select count(distinct artist) from spotify;

select count(distinct album) from spotify;

select max(duration_min) from spotify;

select min(duration_min) from spotify;

select * from spotify
where duration_min = 0;

delete from spotify
where duration_min = 0;

select count(*) from spotify;

select distinct channel from spotify;

select most_played_on , count(*) from spotify
group by 1;

-- ----------------------------------------
-- Data Analysis Easy Category
-- ----------------------------------------
-- 1.Retrieve the names of all tracks that have more than 1 billion streams.
-- 2.List all albums along with their respective artists.
-- 3.Get the total number of comments for tracks where licensed = TRUE.
-- 4.Find all tracks that belong to the album type single.
-- 5.Count the total number of tracks by each artist.

select * from spotify;

-- 1.Retrieve the names of all tracks that have more than 1 billion streams.

select track from spotify
where stream > 1000000000;

-- 2.List all albums along with their respective artists.

select distinct album , artist from spotify
order by 1;

-- 3.Get the total number of comments for tracks where licensed = TRUE.

select sum(comments) as total_commented from spotify
where licensed = 'true';

-- 4.Find all tracks that belong to the album type single.

select * from spotify
where album_type = 'single';

-- 5.Count the total number of tracks by each artist.

select artist , count(track) as total_tracks
from spotify
group by 1;

-- ----------------------------------------
-- Data Analysis Medium Category
-- ----------------------------------------

-- 1.Calculate the average danceability of tracks in each album.
-- 2.Find the top 5 tracks with the highest energy values.
-- 3.List all tracks along with their views and likes where official_video = TRUE.
-- 4.For each album, calculate the total views of all associated tracks.
-- 5.Retrieve the track names that have been streamed on Spotify more than YouTube.

select * from spotify;

-- 1.Calculate the average danceability of tracks in each album.

select album , avg(danceability) as avg_danceability
from spotify
group by 1
order by 2 desc;

-- 2.Find the top 5 tracks with the highest energy values.

select track , max(energy) max_energy
from spotify
group by 1
order by 2 desc
limit 5;

-- 3.List all tracks along with their views and likes where official_video = TRUE.

select track, sum(views)total_views , sum(likes)total_likes
from spotify
where official_video = 'true'
group by 1
order by 2 desc,3 desc;

-- 4.For each album, calculate the total views of all associated tracks.

select album ,track, sum(views) as total_views
from spotify
group by 1, 2
order by 3 desc;

-- 5.Retrieve the track names that have been streamed on Spotify more than YouTube.


select * from 
(select track,
		coalesce(sum(case when most_played_on = 'Spotify' then stream end ),0)as played_by_spotify,
		coalesce(sum(case when most_played_on = 'Youtube' then stream end ),0)as played_by_Youtube
from spotify
group by 1) as t1
where played_by_spotify > played_by_Youtube and played_by_Youtube <>0;


-- ----------------------------------------
-- Data Analysis Advance Category
-- ----------------------------------------

-- 1.Find the top 3 most-viewed tracks for each artist using window functions.
-- 2.Write a query to find tracks where the liveness score is above the average.
-- 3.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
-- 4.Find tracks where the energy-to-liveness ratio is greater than 1.2.
-- 5.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

select * from spotify;

-- 1.Find the top 3 most-viewed tracks for each artist using window functions.

with artist_rank
as
(select artist,
		track,
		sum(views) as total_views,
		dense_rank() over(partition by artist order by sum(views) desc) as rank
from spotify
group by 1,2
order by 1, 3 desc
)

select * from artist_rank
where rank <= 3;

-- 2.Write a query to find tracks where the liveness score is above the average.

select * from spotify
where liveness > (select avg(liveness) from spotify);


-- 3.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

with cte
as(select album,
		max(energy) as highest_energy,
		min(energy) as lowest_energy
from spotify
group by 1
) 

select album , (highest_energy - lowest_energy) as Energy_difference 
from cte
order by 2 desc;


-- 4.Find tracks where the energy & liveness ratio is greater than 1.2.

with cte
as(
select track,
		energy, 
		liveness ,
		(energy/liveness) as ratio
from spotify
where liveness <> 0)

select track,  ratio
from cte
where ration >1.2;

-- 5.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

select track, likes,views,
		sum(likes) over(order by views desc) as cumulative_likes
from spotify;

