### YFExtractor
`YFExtractor` is a tool that captures NZX 50 stock financial data from the Yahoo Finance web service based on a user's subcriptions. It has the following capabilities:

* Captures the live prices of NZX 50 stocks at a configurable time interval
* Displays the last 5 prices of each stock that is subscribed to (if available)
* Creates a text report of NZX 50 stock data that all users are subscribed to on a hourly basis and stores the pdfs in the stockpdfs folder on the server.

### Setup 

* Install all required gems: `bundle install`

* Update the database configuration file 'database.yml'.

* Create database: `rake db:create`

* Run all migrations: `rake db:migrate`

* Seed the database: `rake db:seed`

* Configure the application to your needs: background task intervals (see below)

* Adapt the application to your needs (see below)

* Update the cron jobs: `whenever --update-crontab`

* Start Redis server: `redis-server /usr/local/etc/redis.conf`

* Run application server: `rails s`

* Setup a user account and add subscriptions via Manage Subscriptions page

### Database

YFExtractor uses a PostgreSQL database to build the application. Ensure you have it running on your machine (please refer to: http://www.gotealeaf.com/blog/how-to-install-postgresql-on-a-mac)

### Redis

YFExtractor uses a Redis database to enqueue jobs in Redis to be processed by the cron jobs. Ensure it is running prior to booting the application (please refer to: https://medium.com/@petehouston/install-and-config-redis-on-mac-os-x-via-homebrew-eb8df9a4f298#.e8a56wu3d).

### Background Processes

There are two background processes (cron jobs) running in the application:  
* Retrieving the current stock data 
* Creating a text report of new stock data

### Adapting the Application

The application can be adapted to your own needs in the following ways: 

Change the background task intervals:
* config/schedule.rb 
* After updating the jobs scheduling interval, you will need to run the following command `whenever --update-crontab`

Login to the application:
* Subscribe to stocks in the NZX 50 that you are interested in via the Manage Subscriptions page

### References

* developer.yahoo.com/yql/console

* https://github.com/javan/whenever

* http://finance.yahoo.com/lookup

### Author

* Tania Jacob (https://github.com/jacobtani)