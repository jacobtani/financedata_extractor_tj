				### YFExtractor
================================================
`YFExtractor` is a tool that extracts data from the Yahoo Finance web service. It has the following capabilities:

* Captures the live prices of any commodities or stocks at a configurable time interval (default is 1 minute)
* Displays the last 5 prices of each stock in the Historical Data page
* Creates a text report of current stock data on a hourly basis (default)

### Setup 

* Install all required gems: `bundle install`

* Update the database configuration file 'database.yml'.

* Create database: `rake db:create`

* Run all migrations: `rake db:migrate`

* Configure the application to your needs: stock symbols to process and background task intervals (see below)

* Update the cron jobs: `whenever --update-crontab`

* Start Redis server: `redis-server /usr/local/etc/redis.conf`

* Run application server: `rails s`

### Database

YFExtractor uses a PostgreSQL database to build the application. Ensure you have it running on your machine (please refer to http://www.gotealeaf.com/blog/how-to-install-postgresql-on-a-mac
)

### Redis

YFExtractor uses a Redis database to enqueue jobs in Redis to be processed by the cron jobs. Ensure it is running prior to booting the application. 

### Background Processes:

There are two background processes (cron jobs) running in the application which are as follows: 
* Retrieving the current stock data - every minute
* Creating a text report of new stock data

### Adapting the Application

Change the stock symbols to process:
* config/application.rb

Change the background task intervals:
* config/schedule.rb 
* After updating the jobs in the file described, you will need to run the following command `whenever --update-crontab`

References

* developer.yahoo.com/yql/console

* https://github.com/javan/whenever

* http://finance.yahoo.com/lookup