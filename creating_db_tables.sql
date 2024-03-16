CREATE DATABASE IF NOT EXISTS olympics;
USE olympics;
CREATE TABLE IF NOT exists athelete_events 
(
	ID int not null ,
	name varchar(100),
	sex varchar(5),
    age varchar(10),
	height varchar(10),
	weight varchar(10),
	team varchar(100),
	NOC varchar(5),
	games varchar(100),
	year varchar(10),
	season varchar(100),
	city varchar(100),
	sport varchar(100),
	event varchar(200),
	medal varchar(30)
);
CREATE TABLE IF NOT exists noc_regions
(
	noc varchar(100),
    region varchar(100),
    notes varchar(100)
);

-- DEALING WITH NULL VALUES IN INTEGER DATA TYPES COLUMNS AND REDIFINING THEIR DATA TYPES.
UPDATE  athlete_events
SET age= NULL
WHERE age='';

ALTER TABLE athlete_events
MODIFY age INT;
-- ---------------------------------------------------------------------------------------
UPDATE  athlete_events
SET height= NULL
WHERE height='';

ALTER TABLE athlete_events
MODIFY height INT;
-- --------------------------------------------------------------------------------------------------------------------
UPDATE  athlete_events
SET weight= NULL
WHERE weight='';

ALTER TABLE athlete_events
MODIFY weight INT;
-- ---------------------------------------------------------------------------------------------------------------------
ALTER TABLE athlete_events
MODIFY year INT;








