\i create.sql;
\timing;
COPY postcodes FROM ' C:\postcodes.csv ' DELIMITER ',' CSV;
SELECT COUNT(*) FROM postcodes;
select easting, northing from postcodes where postcode = 'WR3 8AS';
select postcode_district from postcodes where postcode_fixed_width_eight = 'M1   1AA';
select latitude, longitude from postcodes where postcode_no_space = 'RG46SU';
select easting, northing from postcodes where postcode = 'EC3N 4AB';
select postcode, sqrt(pow(abs(533668 - easting),2) + pow(abs(180551 - northing),2)) as distance from postcodes order by distance limit 10;
select postcode, sqrt(pow(abs(533668 - easting),2) + pow(abs(180551 - northing),2)) as distance from postcodes where status = 'live' and easting between 533668 - 500 and 533668 + 500 and northing between 180551 - 500 and 180551 + 500 and postcode != 'EC3N 4AB' order by distance limit 10;

