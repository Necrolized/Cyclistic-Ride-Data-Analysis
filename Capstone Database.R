# ---- Section: Data Preparation ----

##Package Install 

install.packages("tidyverse")
library(tidyverse)


## create tables for each month of data.

X202312 <- read_csv("C:/Users/USER/Desktop/Capstone A/Raw Data/202312-divvy-tripdata.csv")
X202401 <- read_csv("C:/Users/USER/Desktop/Capstone A/Raw Data/202401-divvy-tripdata.csv")
X202402 <- read_csv("C:/Users/USER/Desktop/Capstone A/Raw Data/202402-divvy-tripdata.csv")
X202403 <- read_csv("C:/Users/USER/Desktop/Capstone A/Raw Data/202403-divvy-tripdata.csv")
X202404 <- read_csv("C:/Users/USER/Desktop/Capstone A/Raw Data/202404-divvy-tripdata.csv")
X202405 <- read_csv("C:/Users/USER/Desktop/Capstone A/Raw Data/202405-divvy-tripdata.csv")
X202406 <- read_csv("C:/Users/USER/Desktop/Capstone A/Raw Data/202406-divvy-tripdata.csv")
X202407 <- read_csv("C:/Users/USER/Desktop/Capstone A/Raw Data/202407-divvy-tripdata.csv")
X202408 <- read_csv("C:/Users/USER/Desktop/Capstone A/Raw Data/202408-divvy-tripdata.csv")
X202409 <- read_csv("C:/Users/USER/Desktop/Capstone A/Raw Data/202409-divvy-tripdata.csv")
X202410 <- read_csv("C:/Users/USER/Desktop/Capstone A/Raw Data/202410-divvy-tripdata.csv")
X202411 <- read_csv("C:/Users/USER/Desktop/Capstone A/Raw Data/202411-divvy-tripdata.csv")

## List of data frames to merge
data_frames <- list(X202312, X202401, X202402, 
                    X202403, X202404, X202405, 
                    X202406, X202407, X202408, 
                    X202409, X202410, X202411)

## Merge all data frames by "ride_id"
year_review_filtered <- bind_rows(data_frames)

# ---- Section: Data Cleaning and Verification ----

# Filter to exclude rides with a duration of less than a minute or longer than a day
year_review_filtered <- year_review_filtered %>%
  filter(ride_length >= 60 & ride_length <= 86400)

##ride_id is a unique key: Check no duplicates exist and that all of the values are 16 characters in length.##

# Check for duplicates, 211 duplicates found
duplicates <- year_review_filtered[duplicated(year_review_filtered$ride_id), ]

# remove duplicates, re ran check, no duplicates found. 
year_review_filtered <- year_review_filtered %>%
  distinct(ride_id, .keep_all = TRUE)

# Check for invalid ride_id lengths 
invalid_lengths <- year_review_filtered[nchar(year_review_filtered$ride_id) != 16, ]


## Creating ride_length column: 
# Checking started:at and ended_at column are all in time format. 
year_review_filtered$started_at <- as.POSIXct(year_review_filtered$started_at, format = "%Y-%m-%d %H:%M:%S")
year_review_filtered$ended_at <- as.POSIXct(year_review_filtered$ended_at, format = "%Y-%m-%d %H:%M:%S")
# Calculate ride length in seconds
year_review_filtered$ride_length <- as.numeric(difftime(year_review_filtered$ended_at, year_review_filtered$started_at, units = "secs"))

## Had to change locale so i could have days in english
Sys.setlocale("LC_TIME", "English")
## Creating day of the week column
year_review_filtered$day_of_week <- factor(year_review_filtered$day_of_week, 
                                           levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))



##Checking empty spaces per columns:
# Function to count empty spaces or missing data in a column
count_empty_spaces <- function(column) {
  # Check for POSIXlt or POSIXct columns (date-time columns)
  if (inherits(column, c("POSIXlt", "POSIXct"))) {
    # For date-time columns, count NA or empty
    return(sum(is.na(column)))
  }
  # For other columns, check for NA, empty strings, NaN, and single spaces
  sum(is.na(column) | column == "" | is.nan(column) | column == " " )
}

# Apply the count_empty_spaces function to each of the columns
empty_spaces_count <- sapply(year_review_filtered, count_empty_spaces)

# Convert the result to a data frame for review
empty_spaces_summary <- data.frame(
  Column = names(empty_spaces_count),
  Empty_Spaces = empty_spaces_count
)

# Print the summary of empty spaces
print(empty_spaces_summary)

# Create a season column based on the month of the ride
year_review_filtered$season <- case_when(
  month(year_review_filtered$started_at) %in% c(12, 1, 2) ~ "Winter",    # December, January, February
  month(year_review_filtered$started_at) %in% c(3, 4, 5) ~ "Spring",    # March, April, May
  month(year_review_filtered$started_at) %in% c(6, 7, 8) ~ "Summer",    # June, July, August
  month(year_review_filtered$started_at) %in% c(9, 10, 11) ~ "Fall"     # September, October, November
)

# ---- Section: Data Analysis ----
# ---- Calculations ---- 
# Average ride length. 
mean_ride_length <- mean(year_review_filtered$ride_length, na.rm = TRUE)


#Max ride length
max_ride_length <- max(year_review_filtered$ride_length, na.rm = TRUE)


#Mode function
get_mode <- function(x) {
  uniqx <- unique(x)  
  uniqx[which.max(tabulate(match(x, uniqx)))]  
}
# Mode of day_of_week
mode_day_of_week <- get_mode(year_review_filtered$day_of_week)

# ---- Pivot Tables ----
# Pivot table: Average ride_length for members and casual riders
pivot_table_avg_ride_length <- year_review_filtered %>%
  group_by(member_casual) %>%
  summarize(average_ride_length = mean(ride_length, na.rm = TRUE))

# Pivot table: Average ride_length for users by day_of_week
pivot_table_avg_ride_length_day <- year_review_filtered %>%
  group_by(member_casual, day_of_week) %>%
  summarize(average_ride_length = mean(ride_length, na.rm = TRUE))

# Pivot table: Number of rides by day_of_week
pivot_table_ride_count_day <- year_review_filtered %>%
  group_by(member_casual, day_of_week) %>%
  summarize(ride_count = n()) 

# Pivot table:  average ride_length per day per season 
pivot_table_avg_ride_length_day_season_member <- year_review_filtered %>%
  filter(member_casual == "member") %>%
  group_by(season, day_of_week) %>%
  summarize(average_ride_length = mean(ride_length, na.rm = TRUE))

# Pivot table:  total number of rides by member type
total_rides_by_member_type <- year_review_filtered %>%
  group_by(member_casual) %>%
  summarize(total_rides = n())

# Pivot Table: total number rides by day and season
total_rides_by_member_type_day_season <- year_review_filtered %>%
  group_by(member_casual, day_of_week, season) %>%
  summarize(total_rides = n())

# Pivot table: total usage of ride type
pivot_table_rideable_type_usage <- year_review_filtered %>%
  group_by(rideable_type) %>%
  summarize(total_ride_count = n())  

# Pivot table: total usage of ride type by day and season
pivot_table_rideable_type_usage_by_day_season <- year_review_filtered %>%
  group_by(rideable_type, day_of_week, season) %>%
  summarize(total_ride_count = n())  


# ---- Visualization ----
# Create a pie chart to visualize the average ride length by rider type
ggplot(pivot_table_avg_ride_length, aes(x = "", y = average_ride_length, fill = member_casual)) +
  geom_bar(stat = "identity", width = 1) + 
  coord_polar(theta = "y") +  
  labs(
    title = "Average Ride Length for Members and Casual Riders", 
    x = NULL,
    y = NULL,  
    fill = "Rider Type"
  ) +
  theme_void() +
  geom_text(
    aes(label = paste0(round(average_ride_length, 2))), 
    position = position_stack(vjust = 0.5),  
    color = "white",  
    size = 5  
  )

# Stacked bar chart for average ride length by day_of_week and rider_type
ggplot(pivot_table_avg_ride_length_day, aes(x = day_of_week, y = average_ride_length, fill = member_casual)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(
    title = "Average Ride Length by Day of Week for Members and Casual Riders", 
    x = "Day of Week", 
    y = "Average Ride Length",
    fill = "Rider Type"  
  ) +
  theme_minimal() +
  geom_text(
    aes(label = round(average_ride_length, 2)),  
    position = position_stack(vjust = 0.5),  
    color = "white",  #
    size = 3
  )

# Stacked bar chart for the number of rides by day_of_week and rider_type
ggplot(pivot_table_ride_count_day, aes(x = day_of_week, y = ride_count, fill = member_casual)) +
  geom_bar(stat = "identity") +  
  labs(
    title = "Number of Rides by Day of Week for Members and Casual Riders", 
    x = "Day of Week", 
    y = "Number of Rides",
    fill = "Rider Type"  
  ) +
  theme_minimal() +
  geom_text(
    aes(label = ride_count),  
    position = position_stack(vjust = 0.5),
    color = "white",  
    size = 3  
  )
# Create a grouped bar chart between member_casual and rideable_type
ggplot(year_review_filtered, aes(x = member_casual, fill = rideable_type)) +
  geom_bar(stat = "count", position = "dodge") +  
  labs(
    title = "Number of Rides by Member Type and Rideable Type", 
    x = "Member Type", 
    y = "Number of Rides",
    fill = "Rideable Type"  
  ) +
  theme_minimal() +
  geom_text(
    aes(label = ..count..),  
    stat = "count",
    position = position_dodge(width = 0.8),  
    color = "white",  
    size = 3,
    vjust = 1
  )
# Create a bar chart showing the number of rides by season
ggplot(year_review_filtered, aes(x = season, fill = season)) +
  geom_bar(stat = "count") +  
  labs(
    title = "Number of Rides by Season", 
    x = "Season", 
    y = "Number of Rides",
    fill = "Season"  
  ) +
  theme_minimal() +
  geom_text(
    aes(label = ..count..),  
    stat = "count", 
    color = "white",  
    size = 3, 
    position = position_stack(vjust = 0.5)
  )

# Create a stacked bar chart showing the relationship between season and rideable_type
ggplot(year_review_filtered, aes(x = season, fill = rideable_type)) +
  geom_bar(stat = "count") +  
  labs(
    title = "Relationship Between Season and Rideable Type", 
    x = "Season", 
    y = "Number of Rides",
    fill = "Rideable Type"  
  ) +
  theme_minimal() +
  geom_text(
    aes(label = ..count..),  
    stat = "count", 
    color = "white",  
    size = 3, 
    position = position_stack(vjust = 0.5)
  )

# Create a stacked bar chart showing the relationship between season and number of rides by member type
ggplot(year_review_filtered, aes(x = season, fill = member_casual)) +
  geom_bar(stat = "count") +  
  labs(
    title = "Number of Rides by Season and Member Type", 
    x = "Season", 
    y = "Number of Rides",
    fill = "Member Type"  
  ) +
  theme_minimal() +
  geom_text(
    aes(label = ..count..),  
    stat = "count", 
    color = "white",  
    size = 3, 
    position = position_stack(vjust = 0.5)
  )

# Create a chart for average ride length by member type, day, and season
ggplot(pivot_table_avg_ride_length_by_day_season, aes(x = day_of_week, y = average_ride_length, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ season) +  # Facet by season
  labs(
    title = "Average Ride Length for Member Type by Day of Week and Season", 
    x = "Day of Week", 
    y = "Average Ride Length (seconds)",
    fill = "Member Type"
  ) +
  theme_minimal() +
  geom_text(
    aes(label = round(average_ride_length, 2)),  # Display average ride length on bars
    position = position_dodge(width = 0.8),  
    color = "white",  
    size = 3
  )