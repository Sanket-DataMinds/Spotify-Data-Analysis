# 🎵 Advanced SQL Project: Spotify Dataset

## 📌 Overview
This project analyzes a Spotify dataset using advanced SQL queries. The dataset contains various track details, including streaming metrics, audio features, and platform information. The SQL queries cover exploratory data analysis (EDA), track insights, and other analytical operations.

## 📂 Dataset Information
The dataset contains the following key columns:
- **Artist**: Name of the artist.
- **Track**: Name of the track.
- **Album**: Album name.
- **Album Type**: Type of album (album/single).
- **Danceability**: A measure of a track's danceability.
- **Energy**: Energy level of the track.
- **Loudness**: Loudness in decibels (dB).
- **Speechiness**: Presence of spoken words.
- **Acousticness**: Acoustic property of the track.
- **Instrumentalness**: Instrumental sound presence.
- **Liveness**: Detects the presence of a live audience.
- **Valence**: Musical positivity.
- **Tempo**: Beats per minute (BPM).
- **Duration (min)**: Track duration in minutes.
- **Views**: Number of YouTube views.
- **Likes**: Number of likes on YouTube.
- **Comments**: Number of comments.
- **Licensed**: Whether the track is officially licensed.
- **Official Video**: Whether the track has an official video.
- **Stream**: Total Spotify streams.
- **Most Played On**: Most streamed platform (Spotify/Youtube).

---

## 📊 SQL Queries & Solutions

### 🟢 Easy Questions

#### 1️⃣ Retrieve the names of all tracks that have more than 1 billion streams.
```sql
SELECT track FROM spotify
WHERE stream > 1000000000;
```

#### 2️⃣ List all albums along with their respective artists.
```sql
SELECT DISTINCT album, artist FROM spotify
ORDER BY 1;
```

#### 3️⃣ Get the total number of comments for tracks where licensed = TRUE.
```sql
select sum(comments) as total_commented
from spotify
where licensed = 'true';
```

#### 4️⃣ Find all tracks that belong to the album type single.
```sql
select *
from spotify
where album_type = 'single';
```

#### 5️⃣ Count the total number of tracks by each artist.
```sql
select artist , count(track) as total_tracks
from spotify
group by 1;
```

---

### 🟡 Medium Questions

#### 6️⃣ Calculate the average danceability of tracks in each album.
```sql
select album , avg(danceability) as avg_danceability
from spotify
group by 1
order by 2 desc;
```

#### 7️⃣ Find the top 5 tracks with the highest energy values.
```sql
select track , max(energy) max_energy
from spotify
group by 1
order by 2 desc
limit 5;
```

#### 8️⃣ List all tracks along with their views and likes where official_video = TRUE.
```sql
select track, sum(views)total_views , sum(likes)total_likes
from spotify
where official_video = 'true'
group by 1
order by 2 desc,3 desc;
```

#### 9️⃣ For each album, calculate the total views of all associated tracks.
```sql
select album ,track, sum(views) as total_views
from spotify
group by 1, 2
order by 3 desc;
```

#### 🔟 Retrieve the track names that have been streamed on Spotify more than YouTube.

```sql
select * from 
(select track,
		coalesce(sum(case when most_played_on = 'Spotify' then stream end ),0)as played_by_spotify,
		coalesce(sum(case when most_played_on = 'Youtube' then stream end ),0)as played_by_Youtube
from spotify
group by 1) as t1
where played_by_spotify > played_by_Youtube and played_by_Youtube <>0;

```

---

### 🔴 Advanced Questions

#### 1️⃣1️⃣ find the top 3 most-viewed tracks for each artist using window functions.
```sql
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

```

#### 1️⃣2️⃣ Write a query to find tracks where the liveness score is above the average.
```sql
select * from spotify
where liveness > (select avg(liveness) from spotify);
```

#### 1️⃣3️⃣ Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
```sql
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
```

#### 1️⃣4️⃣ Find tracks where the energy & liveness ratio is greater than 1.2.
```sql

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
```

#### 1️⃣5️⃣ Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

```sql

select track, likes,views,
		sum(likes) over(order by views desc) as cumulative_likes
from spotify;
```

---

## 🚀 How to Use This Project
1. **Load the dataset** into your SQL database.
2. **Run the queries** to gain insights from the dataset.
3. **Modify queries** as needed to explore additional insights.

Feel free to contribute by adding new queries or optimizing existing ones! 🎶

