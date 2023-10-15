# Bfro SQL Exploratory Data Analysis
Exploratory Analysis of BFRO data using SQL, some Excel
Skills demonstrated: Joins, CTE's, Window Functions, Aggregate Functions

## Project Overview
The purpose of this Analysis is to do an exploration of data from the Bigfoot Field Researchers Organization, or BFRO, on Bigfoot sightings within the Continental United States. 
Primarily, I would like to get an understanding of some of the variables in the Dataset, as well as remove any outliers or unnecessary entries. 

## Data Source
This data was sourced from data.world, and was uploaded by Tim Renner. Based on Tim's description of the data on the source page, this data was taken from the BFRO website and subjected to some cleaning in order to be more easily digested and analyzed. The link to the data-set used is below:
https://data.world/timothyrenner/bfro-sightings-data

## Data Overview
The source is made up of 3 actual datasets - one for locations specifically, one for a geocoding of all variables, and one focused on the subject matter reports, titled as bfro_locations, bfro_reports_geocoded, and bfro_reports, respectively. the locatins and geocoded datasets are available in .csv formats, while the reports dataset is a .json file, likely due to the heavier focus on text entries in that dataset. 
For the purposes of this analysis, only bfro_locations and bfro_reports_geocoded were used, and from here on will be referred to as the 'location' and 'geocoded' sets respectively. 
locations features only 6 columns, while geocoded contains 30- primarily we will be querying from the geocoded list, but a few join queries are used for demonstration purposes anyways, sourced from the location dataset, despite being present in the geocoded set as well. The geocoded dataset is quite thorough, and so does not offer many opportunities for eligible joins from other sheets.  

## Analysis
The first thing I did with these datasets was to begin trying to group the sightings by variables. The natural starting point would be to begin with the states themselves and the number of sightings attributable to each state. We will want to group the results by state, and order them by the number of sightings in descneding order:

![Screen Shot 2023-09-19 at 7 20 02 PM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/3117bd39-d4ab-40e4-8341-a8495d9a3526)

This returns the following table via data.world's query tool:

![image](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/a7767ed6-5a41-46ca-bc37-d0133d787ded)

This is helpful information, however, outside of seeing the states where Bigfoot sightings most often occur, it doesn't give us much information regarding trends or outliers. 
Further, the query isn't as helpful as it could be. In reviewing the data, we can see that the 'classification' value within the datasets is very important to our study. There are 3 values for this option: Class A, Class B, and Class C. Class A and B are reported in the datasets as sightings that we can be relatively confident in their legitimacy -  the primary difference between the two would be a lack of a clear visual aspect to the sighting. For example; a sighting that occurs on a clear day without fog or rain on an open clearing, would be viewed as Class A- had there been rain or fog present which obscured the subject, this would be downgraded to Class B. Class C sightings are second or third-hand sources, or ones that cannot be confirmed with great confidence. As a result, we really only want to see valuse from Class A and B, so let's write a line to only see Class A and B:

![Screen Shot 2023-09-19 at 7 28 27 PM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/76b42b9e-084d-4b6f-8873-a46ce44baac9)

Now our data will be cleaner - but our query could be to. This can be condensed into the following:

![Screen Shot 2023-09-19 at 7 29 11 PM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/a8d37a7f-17bb-45ab-98be-80b3a22f0840)

So our updated query will read as follows:

![Screen Shot 2023-09-19 at 7 31 30 PM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/e163cf6c-f61d-498a-8563-d421f99be37a)

and will return the following. As we can see, several sightings have been removed from multiple states. 

![Screen Shot 2023-09-19 at 7 33 12 PM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/88ca11fe-e2fe-46db-9b10-55de4d4544e7)

So we now are beginning to pare down our data into the most reliable and useful sets of sightings. Next, we want to try to see any outliers. 
First, we want to see how the sightings are grouped by date. Given that different states have had different levels of population throughout the Country's history, we want to make sure we are examining a relatively uniform time period. 
To do so, we can use the following query to add in columns for earliest and latest dates for each state, and order by the earliest sightings in a state. This will easily allow us to see if any sightings stand out as being far removed from others.
Although this is not a massively large table that will be created, we will still limit our results to 10, as we don't need a broad scope of this data to see the earliest entries. 

![Screen Shot 2023-09-19 at 7 39 42 PM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/54e9b1a2-e0d1-4992-8ff5-6486114ce998)

This returns the following:

![Screen Shot 2023-09-19 at 7 41 14 PM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/cacc213b-983a-41dd-b37b-d7992807da60)

As we can see, California has by far the earliest date by about 50 years. Let's see how many are that early in California:

![Screen Shot 2023-09-19 at 7 42 58 PM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/391ab927-5012-4781-9907-9d0fa6a5c68f)

The only real trouble date here is the 1869 date- so we will want to remove that from our list. 

![Screen Shot 2023-09-19 at 7 44 01 PM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/90a1d57b-2dde-4750-aaf2-b95fba145ce2)

Now, we can start looking at states and their percentage of sightings. We do this with the below two queries, first to determine the total number of sightings, and then to calculate state-percentages:

![Screen Shot 2023-10-01 at 10 56 43 AM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/5a2aaa1d-c70e-423b-8a7e-072bda4c9d7e)

![Screen Shot 2023-10-01 at 10 56 00 AM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/4d9b5588-8460-49ca-8fbf-436a67ad5444)

If this were not in a data.world hosted query environment, we could also use CTE to accomplish the above:

![Screen Shot 2023-10-01 at 10 57 27 AM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/2e30ae44-0754-476c-95c5-a4ca8abf179b)

Then, utilizing excel, I was able to determine the IQR range to see if there are any states that are outliers. Based on this, we can disregard states with under 27 sightings, as that is below the lowest IQR, as these are outliers based on our dataset. 

Then, we shift to examining latitude and longitudes for later plotting- using a Left Join, we can determine average latitude and longitude values for each states, which would be useful in plotting out any map-based charts. 

![Screen Shot 2023-10-01 at 11 00 37 AM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/11c193be-b155-48a7-b1f7-093256871e98)

Now to move on to analyzing by season. First, we will group the sightings by season using the below query:

![Screen Shot 2023-10-01 at 11 01 28 AM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/4552d16f-ae10-4bd9-b014-fd5fa5da4582)

![Screen Shot 2023-10-01 at 11 02 02 AM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/c3fdbf9f-72f4-4c67-945e-17a33ab73f91)

This 'Unknown' category seems to be potentially problematic, given that it won't help us with anything meaningful in terms of finding trends. Can we remove these sightings based on the above established IQR ranges?

![Screen Shot 2023-10-01 at 11 04 33 AM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/e1ab1758-fc1c-4513-8726-36c87b162b76)


The above query yields the following table:

![Screen Shot 2023-10-01 at 11 04 47 AM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/64904388-f7e3-4840-be70-9635d2034c38)

We can see here that the number of sightings in an Unknown season by state is well below the limit of 27 we found in our earlier query. As a result, we can disregard these sightings as well as outliers that are not statistically significant. 

Finally, we want to examine the number of sightings by season, by state:

![Screen Shot 2023-10-01 at 11 09 58 AM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/80f18156-17bb-4ad6-b009-f180647fcb47)

![Screen Shot 2023-10-01 at 11 10 43 AM](https://github.com/timjb96/Bfro_SQL_EDA/assets/112847821/27bdfc56-fdd5-42c2-9760-74ec45be3248)

The above analysis allows us to draw some helpful conclusions. Primarily, it shows us states like California, Oregon and Washington on the West Coast are some of the states with the highest number of sightings, as well as Florida and Ohio. Additionally, we can see that Summer is the season in which individuals are most likely to see a Bigfoot. 

However, this unfortunately gives us little in the way of finding a trend that causes more sightings to occur in one region vs. another. Since the majority of sightings occur in States like Washington, California, Florida, and Oregon, which are known for their outdoor activities and hiking/camping, and in the Summer when the majority of such activities would take place, we can explain most of what we're seeing in this data as 'people are out in the wilderness more often in Summer in states known for their hiking and camping options; therefore, people are more likely to experience a Bigfoot sighting, as they are more likely to be in the area where a sighting would occur.

Further, this also suggests that weather may have some affect on the number of reports themselves- winter months are more likely to cause visibility issues that may downgrade a report from a reliable A or B to a Class C.







