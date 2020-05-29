import time
import pandas as pd
import numpy as np

CITY_DATA = { 'chicago': 'chicago.csv',
              'new york city': 'new_york_city.csv',
              'washington': 'washington.csv' }

def get_filters():
    """
    Asks user to specify a city, month, and day to analyze.

    Returns:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    """
    print('Hello! Let\'s explore some US bikeshare data!')

    cities = ['chicago', 'new york city', 'washington']
    while True:
        city = input('\n Would you like to see date for Chicago, New York City, or Washington?\n').lower()
        if city in cities:
            break
        else:
            print('\nPlease type in a valid city, either chicago, new york city, or washington.\n')


    month_input = ['January', 'February', 'March', 'April', 'May', 'June','None']
    while True:
        month=input('which month? January, February, March, April, May, or June? \
        \nPlease type out the full month name.  Type "none" for no month filer.\n').title()
        if month in month_input:
            break
        else:
            print('Please type out one full month name or "none".\n')


    weekdays_input = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday','None']
    while True:
        day=input('which day? Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, or Saturday? \
         \nPlease type out the full day name.  Type "none" for no day filter.\n').title()
        if day in weekdays_input:
            break
        else:
            print('Please type out one full day name or "none".\n')

    print('-'*40)
    return city, month, day


def load_data(city, month, day):
    """
    Loads data for the specified city and filters by month and day if applicable.

    Args:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "none" to apply no month filter
        (str) day - name of the day of week to filter by, or "none" to apply no day filter
    Returns:
        df - Pandas DataFrame containing city data filtered by month and day
    """
    df=pd.read_csv(CITY_DATA[city].lower())

    df['Start Time']=pd.to_datetime(df['Start Time'])
    df['month']=df['Start Time'].dt.month
    df['day_of_week']=df['Start Time'].dt.weekday_name

    if month != 'None':
        months=['january', 'february', 'march', 'april', 'may', 'june']
        month=months.index(month.lower())+1
        df=df[df['month']==month]

    if day != 'None':
        df=df[df['day_of_week']==day.title()]

    return df


def time_stats(df):
    """Displays statistics on the most frequent times of travel."""

    print('\nCalculating The Most Frequent Times of Travel...\n')
    start_time = time.time()

    """Display the most common month"""
    popular_month=df['month'].mode()[0]

    """Display the most common day of week"""
    popular_day=df['day_of_week'].mode()[0]

    """Display the most common start hour"""
    df['hour']=df['Start Time'].dt.hour
    popular_hour=df['hour'].mode()[0]

    print("\nThe most popular month is {}; \
           \nThe most popular day of week is {}; \
           \nThe most popular start hour is {}".format(popular_month, popular_day, popular_hour))
    print("\nThis took %s seconds." % (time.time() - start_time))

    print('-'*40)


def station_stats(df):
    """Displays statistics on the most popular stations and trip."""

    print('\nCalculating The Most Popular Stations and Trip...\n')
    start_time = time.time()

    """Display most commonly used start station"""
    popular_start=df['Start Station'].mode()[0]

    """Display most commonly used end station"""
    popular_end=df['End Station'].mode()[0]

    """Display most frequent combination of start station and end station trip"""
    popular_trip=df.groupby(['Start Station', 'End Station']).size().nlargest(1)

    print("\nThe most popular start station is {}; \
           \nThe most popular end station is {}; \
           \nThe most popular trip from start to end is \n{}".format(popular_start, popular_end, popular_trip))
    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)

def trip_duration_stats(df):
    """Displays statistics on the total and average trip duration."""

    print('\nCalculating Trip Duration...\n')
    start_time = time.time()

    """Display total travel time"""
    df['End Time']=pd.to_datetime(df['End Time'])
    df['duration']=df['End Time']-df['Start Time']
    total_duration=df['duration'].sum()

    """Display mean travel time"""
    mean_duration=df['duration'].mean()

    print("\nTotal travel time is {}; \
           \nThe mean travel time is {}".format(total_duration, mean_duration))
    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def user_stats(df):
    """Displays statistics on bikeshare users."""

    print('\nCalculating User Stats...\n')
    start_time = time.time()

    """Display counts of user types"""
    user_counts=df['User Type'].value_counts()
    print("\nThe breakdown of users is: \n{}".format(user_counts))

    """Display counts of gender"""
    if 'Gender' in df.columns:
        gender_counts=df['Gender'].value_counts()
        print("\nThe breakdown of gender is \n{}".format(gender_counts))
    else:
        print( "this city does not have gender data")


    """Display earliest, most recent, and most common year of birth"""
    if 'Birth Year' in df.columns:
        earliest_birth=df['Birth Year'].min()
        recent_birth=df['Birth Year'].max()
        common_birth=df['Birth Year'].mode()[0]
        print("\nThe earliest year of birth is \n{}".format(earliest_birth))
        print("\nThe most recent year of birth is \n{}".format(recent_birth))
        print("\nThe most common year of birth is \n{}".format(common_birth))

    else:
        print("this city does not have birth year data")


    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)

def raw_data(df):
    """
    Asks user whether they would like to see the raw data.

    Returns:
        If the user answers 'yes,' then the script should print 5 rows of the data at a time, then ask the user if they would like to see 5 more rows of the data.

    """
    """Get user input for city (chicago, new york city, washington). """
    N=0

    while True:
        reply = input('\n Do you want to see some raw data?  Enter yes or no \n').lower()
        if reply=="no":
            break
        elif reply=="yes":
            print(df.iloc[N:(N+5)])
            N+=5
        else:
            print('\nPlease type in either yes or no.\n')

def main():
    while True:
        city, month, day = get_filters()
        df = load_data(city, month, day)

        time_stats(df)
        station_stats(df)
        trip_duration_stats(df)
        user_stats(df)
        raw_data(df)

        restart = input('\nWould you like to restart? Enter yes or no.\n')
        if restart.lower() != 'yes':
            break


if __name__ == "__main__":
	main()
