# Cyclistic Bike Share Analysis (Google Analytics Capstone)

## Overview

This project analyzes Cyclistic bike share data over the last 12 months to uncover trends and insights about user behavior. The analysis focuses on identifying differences between Cyclistic members and casual riders and provides actionable recommendations to improve service and user engagement.

---

## Data Preparation

### Data Import

- **Data Source**: 12 months of Divvy Trip data were used for this analysis from December 2023 to November 2024, the dataset can be found on https://divvy-tripdata.s3.amazonaws.com/index.html.
- **Data Integration**: Monthly datasets were merged into a single data frame to facilitate comprehensive analysis.

---

## Data Cleaning and Verification

- **Ride ID Validation**: Verified that all `ride_id` entries are unique and of correct length (16 characters).
- **Missing Data**: Analyzed and summarized missing or empty values across columns for resolution. Most missing values are on column that don't affect the result of the analysis so we didn't do anything with them. 

---

## Data Manipulation

### Derived Columns

- **Ride Length**: Calculated ride duration in seconds to analyze trip lengths. Excluded rides with durations less than a minute or longer than a day to ensure accurate data representation.
- **Day of the Week**: Extracted the weekday from the start time to evaluate usage patterns.
- **Season**: Categorized data into seasons (Spring, Summer, Fall, Winter) based on the ride start month.

---

## Data Analysis

### Key Metrics

1. **Average Ride Length**: Assessed mean ride duration for members and casual riders.
2. **Total Rides**: Evaluated total rides taken by both user groups across different time periods.
3. **Seasonal Trends**: Analyzed ride patterns by season to understand user preferences.

### Visualizations

- **Average Ride Length by User Type**  
  ![Average ride length by member type](https://github.com/user-attachments/assets/f2f3b60a-4ce7-4c9b-a02a-e811c54beb0b)


- **Average Ride Length by Day and Season**  
![Average ride length for member type by day and season](https://github.com/user-attachments/assets/5cc4d3f0-3b64-44c9-b64f-d25640f2dcb3)


- **Total Rides by User Type**  
![Total rides by member type last year](https://github.com/user-attachments/assets/53c2eea5-f9fb-48d6-9c6c-5513f44f74ea)


- **Total Rides by Day and Season**  
![Total rides by day and season](https://github.com/user-attachments/assets/0c25fe46-5767-4b97-9ccf-b048c60bdd7c)


- **Rideable Type Usage**  
![Total usage time per ride type](https://github.com/user-attachments/assets/1c5b995d-4dc9-43d3-b353-8d4a803b5780)


- **Rideable Type Usage by Day and Season**  
![Bike type usage per day per season](https://github.com/user-attachments/assets/c65fbb78-d5f0-4ef8-8e09-53ac6214d454)


---

## Insights

1. **Seasonality**: Both Cyclistic user types favor cycling in the spring and summer months, with a sharp decline in usage during colder months.
2. **Usage Patterns**:
   - **Members**: Show consistent usage throughout the week, likely for commuting or practical trips.
   - **Casual Riders**: Ride primarily on weekends, likely for recreational purposes.
3. **Ride Lengths**: Casual riders tend to have longer ride durations compared to members.
4. **Bike Preference**: Both groups prefer classic bikes, though electric bike usage increases in fall and winter.
5. **Weekend Trends**: Both groups have longer ride durations on weekends compared to weekdays.

---

## Recommendations

1. **Targeted Marketing Campaigns**:
   - Focus marketing efforts in spring and summer at tourist and recreational hotspots to engage casual riders.

2. **Weekend Subscription Plan**:
   - Introduce a weekend-specific subscription to cater to casual riders, encouraging frequent usage.

3. **Incentivize Memberships**:
   - Offer discounts for longer rides to attract casual riders to become members, especially those who prefer leisurely rides.

4. **Winter Electric Bike Promotions**:
   - Provide discounts on electric bikes during winter to increase usage among both user groups during colder months.

---
