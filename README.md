## Data set
The data is taken from [Kaggle SF Crime Challenge](https://www.kaggle.com/c/sf-crime) and processed by the following code.
```
crime <- fread("train.csv", stringsAsFactors = F)
#crime$month <- months(as.Date(crime$Dates))
#crime$year <- year(as.Date(crime$Dates))
#crime$day <- mday(as.Date(crime$Dates))
crime$Category <- tolower(crime$Category)

crime <- crime %>%
  filter(Category %in% c("assault", "kidnapping", "robbery", "sex offenses forcible")) %>%
  mutate(year = year(as.Date(Dates))) %>%
  select(year, Category, X, Y)
```
Due to the size of the original data, I chose to only use those for serious violent crimes (assualt, kidnapping, robbery and sex offenses forcible).

## App 
In this app, you can chosse to view the crime density map for each crime categories all together or individually. You can also specify the year range. Due to the calling from map api, you may experiencing some delay.

In the second tab, you can see the count of crimes for each category year by year.

In the third tab, a table is presented and you can sort, select and etc.