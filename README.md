# Timezonify    [![Gem Version](https://badge.fury.io/rb/timezonify.png)](http://badge.fury.io/rb/timezonify)   [![Build Status](https://travis-ci.org/gemathon-warriors/timezonify.png?branch=master)](https://travis-ci.org/gemathon-warriors/timezonify)   
<!--  [![Coverage Status](https://coveralls.io/repos/gemathon-warriors/timezonify/badge.png)](https://coveralls.io/r/gemathon-warriors/timezonify) -->

> Wanna hold the World Clock in your hands ?? Then its about "time" you use timezonify.


## Supports

    Ruby 1.8.7+, Rails 2.3.16+

> Warning for 1.8.7 users : Use at your own risk as Ruby community has dropped support for 1.8.7

## Installation

Add this line to your application's Gemfile:

    gem 'timezonify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install timezonify

## Usage

If you want to find your `current timezone` then simply execute this

    Timezonify::Timezone.local_zone #=> "GMT-05"

If you want to find the `list of all countries falling in a specific timezone` then execute this

	Timezonify::Timezone.find_country_in_timezone("GMT+13") #=> ["Kiribati: Phoenix Islands", "New Zealand ('during Daylight Saving Time')", "Samoa", "South Pole ('during Daylight Saving Time')", "Tonga"]

If you want to find the `timezone for a specific time` then execute this

	 Timezonify::Timezone.timezone_for_time('10:00 AM') #=> "GMT+03:30"

If you want to find the `time in a specific timezone` then execute this

	Timezonify::Timezone.find_time_at("GMT+5:30") #=> Fri, 21 Feb 2014 11:59:18 IST +05:30

## Contributing

1. Fork it ( http://github.com/<my-github-username>/timezonify/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
