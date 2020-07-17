# This project explores data related to bike share systems for three major cities in the United States.\n  
# Use R to explore the data and answer interesting questions about it by computing descriptive statistics and making visualizations.

# Load data sets
ny = read.csv('/Users/lichao/Documents/beifen11/我/学习/Programming_for_Data_Science_with_R/lesson\ 4/new_york_city.csv')
wash = read.csv('/Users/lichao/Documents/beifen11/我/学习/Programming_for_Data_Science_with_R/lesson\ 4/washington.csv')
chi = read.csv('/Users/lichao/Documents/beifen11/我/学习/Programming_for_Data_Science_with_R/lesson\ 4/chicago.csv')

# Check data sets
head(ny)
head(wash)
tail(wash)
head(chi)

#..........................Q1 Exploration..............................#

# Q1 What is the most common month? (i.e., occurs most often in the start time)
library(lubridate)

month <- function(city) {
  start_date <-
    sapply(strsplit(as.character(city$Start.Time), " "), "[", 1)
  # extract month from the datatime
  month <- substr(x = start_date, 6, 7)
}

# Call the month function to Chicago
month_chi <- month(chi)
# set a new column with the month data
chi['month'] <- month_chi
# list the month column to check when needed
#chi['month']

# Call the month function to New York when needed
month_ny <- month(ny)
ny['month'] <- month_ny
#ny['month']

# Call the month function to Washington when needed
month_wash <- month(wash)
wash['month'] <- month_wash
#wash['month']


# replacing '01' with 'january' and '02' with 'February' and so on ...
old <- c('01', '02', '03', '04', '05', '06')
new <- c('January', 'Febraury', 'March', 'April', 'May', 'June')
chi$month[chi$month %in% old] <-
  new[match(chi$month, old, nomatch = 0)]
ny$month[ny$month %in% old] <-
  new[match(ny$month, old, nomatch = 0)]
wash$month[wash$month %in% old] <-
  new[match(wash$month, old, nomatch = 0)]

# find the unique values of months
# check the list when needed
#chi['month']
uniqv_chi <- unique(chi$month)
#ny['month']
uniqv_ny <- unique(ny$month)
#wash['month']
uniqv_wash <- unique(wash$month)

# check the list when needed
#uniqv_chi
#uniqv_ny
#uniqv_wash

# find the mode of the month
common_month <- function(data_column,uniqv) {
  uniqv[which.max(tabulate(match(data_column, uniqv)))]   
}


# call the most common month function to Chicago
common_m_chi <- common_month(chi$month,uniqv_chi)
cat('The most common month for Chicago is:', common_m_chi,'\n')

# call the most common month function to New York
common_m_ny <- common_month(ny$month,uniqv_ny)
cat('The most common month for New York is:', common_m_ny,'\n')

# call the most common month function to Washington
common_m_wash <- common_month(wash$month,uniqv_wash)
cat('The most common month for Washington is:', common_m_wash)


#......................Q1 Visualization.......................#
  
# Show the plot of month count with ggplot
  
#Plot for Chicago
library(ggplot2)
#sort the months
chi$month <- factor(chi$month,levels = c('January', 'Febraury', 'March', 'April', 'May', 'June'))
ggplot(aes(chi$month),data=chi)+
  geom_bar(color='black',fill='#099DD9')+
  labs(x='Months',y='Counts for each month',title='Usage of Each Month in Chicago')

#Plot for New York
#sort the months
ny$month <- factor(ny$month,levels = c('January', 'Febraury', 'March', 'April', 'May', 'June'))
ggplot(aes(ny$month),data=ny)+
  geom_bar(color='black',fill='#099DD9')+
  labs(x='Months',y='Counts for each month',title='Usage of Each Month in New York')

#Plot for Washington
#sort the months
wash$month <- factor(wash$month,levels = c('January', 'Febraury', 'March', 'April', 'May', 'June'))
ggplot(aes(wash$month),data=wash)+
  geom_bar(color='black',fill='#099DD9')+
  labs(x='Months',y='Counts for each month',title='Usage of Each Month in Washington')+
  scale_x_discrete(limits= c('January', 'Febraury', 'March', 'April', 'May', 'June'))

# Show the plot of month count with qplot when needed

#qplot(x=chi$month,data=chi,xlab='Months',ylab='Count for each month',main='Usage of Each Month in Chicago',
#     color = I('Black'),fill = I('#099DD9'))

#.......................Q1 Table Summary............................#

# Numeric Summary
  
summary(chi$month)
summary(ny$month)
summary(wash$month)


#.......................Q2 Exploration...............................#
# What is the most common start station?

# find the unique values of start stations

uniqv_ss_chi <- unique(chi$Start.Station)

uniqv_ss_ny <- unique(ny$Start.Station)

uniqv_ss_wash <- unique(wash$Start.Station)

# check the list when needed
uniqv_ss_chi
uniqv_ss_ny
uniqv_ss_wash

# find the mode of the start stations
common_ss <- function(data_column,uniqv_ss) {
  uniqv_ss[which.max(tabulate(match(data_column, uniqv_ss)))]   
}


# call the most common month function to Chicago
common_ss_chi <- common_ss(chi$Start.Station,uniqv_ss_chi)
print('The most common start station for Chicago is:') 
common_ss_chi

# call the most common month function to New York
common_ss_ny <- common_ss(ny$Start.Station,uniqv_ss_ny)
print('The most common start station for New York is:') 
common_ss_ny

# call the most common month function to Washington
common_ss_wash <- common_ss(wash$Start.Station,uniqv_ss_wash)
print('The most common start station for Washington is:') 
common_ss_wash


#......................Q2 Visualization.......................#
# Show the plot of start station count with ggplot

#Plot for Chicago
library(ggplot2)
library(scales)

ggplot(aes(chi$Start.Station),data=chi)+
  geom_bar(color='black',fill='#099DD9')+
  labs(x='Stations',y='Counts for each station',title='All Starting Stations in Chicago')

#want to limit data to a handful and show the label cearly
ggplot(aes(chi$Start.Station),data=chi)+
  geom_bar(stat="count",color='black',fill='#099DD9')+
  labs(x='Stations',y='Counts for each station',title='Starting Stations with More than 100 Usage in Chicago')+
  #scale_y_continuous(limits = c(3000, 7000))+
  #coord_cartesian(ylim = c(100, 250))+
  coord_flip()+
  #coord_cartesian(ylim = c(3000, 7000))+
  scale_x_continuous(limits = c(3000, 7000))+
  scale_x_discrete(labels = wrap_format(5))

#Plot for New York

ggplot(aes(ny$Start.Station),data=ny)+
  geom_bar(color='black',fill='#099DD9')+
  labs(x='Stations',y='Counts for each station',title='Starting Stations in New York')

#want to limit data to a handful and show the label cearly
ggplot(aes(ny$Start.Station),data=ny)+
  geom_bar(stat="count",color='black',fill='#099DD9')+
  labs(x='Stations',y='Counts for each station',title='Starting Stations with More than 100 Usage in New York')+
  #scale_y_continuous(limits = c(2000, 4000))+
  #coord_cartesian(ylim = c(100, 250))+
  coord_flip()+
  #coord_cartesian(ylim = c(3000, 7000))+
  scale_x_continuous(limits = c(2000, 4000))+
  scale_x_discrete(labels = wrap_format(5))


#Plot for Washington

ggplot(aes(wash$Start.Station),data=wash)+
  geom_bar(color='black',fill='#099DD9')+
  labs(x='Stations',y='Counts for each station',title='Starting Stations in Washington')

#.......................Q2 Table Summary............................#

summary(chi$Start.Station)
summary(ny$Start.Station)
summary(wash$Start.Station)

#.......................Q3 Exploration...............................#
# What is the average travel time for users in different cities?

names(ny)

duration_chi = mean(chi$Trip.Duration)
duration_ny = mean(ny$Trip.Duration)
duration_wash = mean(wash$Trip.Duration)

cat('The average travel time for Chicago is:', duration_chi,'\n')
cat('The average travel time for New York is:', duration_ny,'\n')
cat('The average travel time for Washington is:', duration_wash,'\n')

#......................Q3 Visualization.......................#
#Plot for Chicago
ggplot(aes(x=Trip.Duration),data=chi)+
  geom_histogram(binwidth = 100)+
  ggtitle('The Bar Plot of Average Travel Time of Chicago')+
  scale_x_continuous(limits = c(0,5000))+
  labs(x='Usages',y='Travel Time')+
  geom_hline(aes(yintercept = mean(Trip.Duration)),col='red',size=1)

#Plot for New York
ggplot(aes(x=Trip.Duration),data=ny)+
  geom_histogram(binwidth = 100)+
  ggtitle('The Bar Plot of Average Travel Time of New York')+
  scale_x_continuous(limits = c(0,5000))+
  labs(x='Usages',y='Travel Time')+
  geom_hline(aes(yintercept = mean(Trip.Duration)),col='red',size=1)

#Plot for Washington
ggplot(aes(x=Trip.Duration),data=ny)+
  geom_histogram(binwidth = 100)+
  ggtitle('The Bar Plot of Average Travel Time of Washington')+
  scale_x_continuous(limits = c(0,5000))+
  labs(x='Usages',y='Travel Time')+
  geom_hline(aes(yintercept = mean(Trip.Duration)),col='red',size=1)


