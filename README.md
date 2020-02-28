# README

I chose the approach of working only with the text db (more fun).
This application has been stripped down to use only ActionController.

The backups entries are available in db/backups.txt.
The logs are available in public/logs.txt or from browser at http://localhost:3000/logs.txt (public for the sake of easy browsing via web) 

Gems are of course managed by bundler.
In order to run you simply use `bundle exec rails s`

## Some notes

### Repository

Here is a storage handlers for the backups and logs. This is not usual in the Rails world.
I took this principle from the JAVA world, working here with custom data sources.

### Models

Models aren't Rails models, but simple PORO.

### Some info

* Ruby version

2.6.1

* System dependencies

None

* Configuration

Change db/backups.txt to your choice.

* How to run the test suite

Simply `bundle exec rspec`
