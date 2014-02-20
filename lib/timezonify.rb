#!/bin/env ruby
# encoding: utf-8

require "timezonify/version"
require 'active_support'
require 'active_support/version'

if ActiveSupport::VERSION::MAJOR > 2
  require 'active_support/core_ext/numeric'
end

module Timezonify
  class Timezone

    def self.find_country_in_timezone(timezone)
      Mapping.timezone_country["#{timezone.gsub('+0','+').gsub(':00','')}"]
    end

    def self.local_zone
      timezone_for_time(Time.now)
    end

    def self.timezone_for_time(time='Time.now.utc')
      offset = find_offset_for_required_time(time.to_s, current_time="#{Time.now.utc.strftime("%I:%M %p UTC")}")
      ((offset < 0) ? formatted_negative_offset(offset) : formatted_positive_offset(offset))
    end

    private

    def self.find_offset_for_required_time(required_time='8:00 AM UTC', current_time="#{Time.now.utc.strftime("%I:%M %p UTC")}")
      current_time_in_hours  = TimeHelper.time_in_hours(Time.parse(required_time))
      required_time_in_hours = TimeHelper.time_in_hours(Time.parse(current_time))
      (current_time < required_time) ? offset_calculator(required_time_in_hours,current_time_in_hours) : offset_calculator(current_time_in_hours,required_time_in_hours)
    end

    def self.offset_calculator(time1,time2)
      -(time1 - time2)
    end

    def self.formatted_positive_offset(offset_in_hours)
      return 'GMT' if (offset_in_hours == 0)
      offset_hours = hour_from_offset(offset_in_hours)
      offset_minutes = minutes_from_offset(offset_in_hours)
      timezone_as_string(offset_hours, offset_minutes, '+')
    end

    def self.formatted_negative_offset(negative_offset_in_hours)
      offset_in_hours = negative_offset_in_hours.to_s.split('-').last.to_f
      offset_hours    = hour_from_offset(offset_in_hours)
      offset_minutes  = minutes_from_offset(offset_in_hours)
      timezone_as_string(offset_hours, offset_minutes, '-')
    end

    def self.hour_from_offset(offset_in_hours)
      offset_in_hours.to_s.split('.').first.to_i
    end

    def self.minutes_from_offset(offset_in_hours)
      offset_in_hours.to_s.split('.').last.to_i
    end

    def self.timezone_as_string(offset_hours, offset_minutes, state)
      if offset_minutes > 0
        if offset_hours < 10
          "GMT#{state}0" + "#{offset_hours}" + ":30"
        else
          "GMT#{state}" + "#{offset_hours}" + ":30"
        end
      else
        if offset_hours < 10
          "GMT#{state}0" + "#{offset_hours}"
        else
          "GMT#{state}" + "#{offset_hours}"
        end
      end
    end
  end

  class TimeHelper
    def self.time_in_hours(time)
      (time.strftime("%H").to_f + (((time.strftime("%M")).to_f)/60).round(1))
    end
  end 

  class TimezoneHelper
    def self.find_all_timezones_with_offset(offset_in_hours)
      offset_in_seconds = offset_in_hours * 3600
      ActiveSupport::TimeZone.all.select{|tz| tz.utc_offset == offset_in_seconds}
    end
  end

class Mapping

    def self.timezone_country

      {
        "GMT+14" => [ "Kiribati Line Islands|Kiribati Line Islands", "Samoa ('during Daylight Saving Time')", "New Zealand: Tokelau" ],

        "GMT+13:45" => [ "New Zealand: Chatham Islands ('during Daylight Saving Time')" ],

        "GMT+13" => [ "Kiribati: Phoenix Islands", "New Zealand ('during Daylight Saving Time')", "Samoa", "South Pole ('during Daylight Saving Time')", "Tonga" ],

        "GMT+12:45" => [ "New Zealand: Chatham Islands" ],

        "GMT+12" => [ "Fiji", "Kiribati: Gilbert Islands", "Marshall Islands", "Nauru", "New Zealand", "Russia: Chukotka, Kamchatka", "South Pole", "Tuvalu", "Wake Island", "Wallis and Futuna" ],

        "GMT+11:30" => [ "Australia: Norfolk Island" ],

        "GMT+11" => [ "Australia: Australian Capital Territory, New South Wales (except Broken Hill), Tasmania, Victoria (state)|Victoria ('Australian Eastern Daylight Time')", "Federated States of Micronesia: Kosrae, Pohnpei ", "New Caledonia", "Russia: Sakhalin Oblast|Kuril Islands, Magadan Oblast, Yakutia|Sakha", "Solomon Islands", "Vanuatu" ],

        "GMT+10:30" => [ "Australia: South Australia, Broken Hill (New South Wales) ('Australian Central Daylight Time')" ],

        "GMT+10" => [ "Australia: Australian Capital Territory, New South Wales (except Broken Hill), Queensland, Tasmania, Victoria (state)|Victoria ('Australian Eastern Standard Time')", "Federated States of Micronesia: Chuuk, Yap", "Guam", "Northern Mariana Islands", "Papua New Guinea", "Russia: Primorsky Krai, Khabarovsk  Krai, Yakutia, Sakhalin Oblast|Sakhalin Island" ],

        "GMT+9:30" => [ "Australia: Northern Territory, South Australia, Broken Hill (New South Wales) ('Australian Central Standard Time')" ],

        "GMT+9" =>
        [ "East Timor", "Indonesia (eastern): Maluku, Western New Guinea", "Japan", "North Korea", "South Korea", "Palau", "Russia: Amur Oblast, Zabaykalsky Krai, Yakutia" ],

        "GMT+8" => [ "Australia: Western Australia ('Australian Western Standard Time')", "Brunei", "China", "Hong Kong", "Indonesia (central): (Bali, Borneo)", "Macau", "Malaysia", "Mongolia (most of country)", "Philippines", "Singapore", "Taiwan", "Russia: Buryatia, Irkutsk Oblast" ],

        "GMT+7" => [ "Bangladesh", "Cambodia", "Christmas Island (Australia)", "Indonesia (western): (Java, Sumatra)", "Laos", "Mongolia (Hovd, Uvs, and Bayan-Ölgii)", "Russia: Kemerovo, Khakassia, Krasnoyarsk Krai, Tomsk, Tuva", "Thailand", "Vietnam" ],

        "GMT+6:30" => [ "Cocos Islands", "Myanmar" ],

        "GMT+6" => [ "Bhutan", "British Indian Ocean Territory (CIA)", "Kazakhstan (Eastern)", "Kyrgyzstan", "Russia: Altai Krai, Altai Republic, Novosibirsk Oblast, Omsk Oblast, Tomsk Oblast" ],

        "GMT+5:45" => [ "Nepal" ],

        "GMT+5:30" => [ "India", "Sri Lanka" ],

        "GMT+5" => [ "British Indian Ocean Territory (NAO)", "French Southern and Antarctic Lands", "Heard Island and McDonald Islands", "Kazakhstan (Western)", "Maldives", "Pakistan", "Russia: Astrakhan, Bashkortostan, Chelyabinsk, Kurgan, Orenburg, Perm, Saratov, Sverdlovsk, Tyumen, Ulyanovsk, Volgograd", "Tajikistan", "Turkmenistan", "Uzbekistan" ],

        "GMT+4:30" => [ "Afghanistan" ],

        "GMT+4" => [ "Armenia", "Azerbaijan", "Georgia (country)|Georgia", "Mauritius", "Oman", "Réunion", "Russia: Samara, Udmurtia", "Seychelles", "United Arab Emirates" ],

        "GMT+3:30" => [ "Iran" ],

        "GMT+3" => [ "Bahrain", "Comoros", "Djibouti", "Eritrea", "Ethiopia", "Iraq", "Kenya", "Kuwait", "Madagascar", "Mayotte", "Qatar", "Russia: most of European portion, including Moscow, Saint Petersburg, Rostov on Don, Novaya Zemlya, Franz Josef Land, and all railroads throughout Russia", "Saudi Arabia", "Somalia", "Sudan", "Tanzania", "Uganda", "Yemen" ],

        "GMT+2" => [ "Belarus", "Botswana", "Bulgaria", "Burundi", "Democratic Republic of the Congo (eastern)", "Cyprus", "Egypt", "Estonia", "Finland", "Greece", "Israel", "Jordan", "Latvia", "Lebanon", "Lesotho", "Libya", "Lithuania", "Malawi", "Moldova", "Mozambique", "Romania", "Russia: Kaliningrad Oblast", "Rwanda", "South Africa", "Swaziland", "Syria", "Turkey", "Ukraine", "Zambia", "Zimbabwe" ],

        "GMT+1" => [ "Albania", "Andorra", "Algeria", "Angola", "Austria", "Belgium", "Benin", "Bosnia and Herzegovina", "Cameroon", "Central African Republic", "Chad", "Republic of the Congo", "Democratic Republic of the Congo (western)", "Croatia", "Czech Republic", "Denmark", "Equatorial Guinea", "France", "Gabon", "Germany", "Gibraltar", "Hungary", "Italy", "Liechtenstein", "Luxembourg", "Republic of Macedonia", "Malta", "Monaco", "Montenegro", "Namibia", "Netherlands", "Niger", "Nigeria", "Norway", "Poland", "San Marino", "Serbia", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland", "Tunisia", "Rome/Vatican|Vatican City" ],

        "GMT" => [ "Burkina Faso", "Bouvet Island", "Canary Islands", "Cote d'Ivoire", "Faroe Islands", "Gambia", "Ghana", "Greenland (northeastern)", "Guernsey", "Guinea", "Guinea-Bissau", "Iceland", "Ireland", "Isle of Man", "Jersey", "Liberia", "Mali", "Mauritania", "Morocco", "Northern Ireland", "Portugal", "Saint Helena (island)|Saint Helena", "Senegal", "Sierra Leone", "Sao Tome and Principe", "Togo", "United Kingdom", "Western Sahara" ],

        "GMT-1" => [ "Azores (Portugal)", "Cape Verde", "Greenland (east)" ],

        "GMT-2" => [ "Fernando de Noronha (Brazil)", "South Georgia and the South Sandwich Islands", "Trindade and Martim Vaz (uninhabited islands) (Brazil)" ],

        "GMT-3" => [ "Argentina", "Brazil: Brasilia, Rio de Janeiro|Rio, São Paulo, Fortaleza, Maceio, Recife, Salvador etc.", "French Guiana", "Greenland (central)", "Guyana", "Saint Pierre and Miquelon", "Suriname", "Uruguay" ],

        "GMT-3:30" => [ "Canada ('Newfoundland Time'): Newfoundland and Labrador" ],

        "GMT-4" => [ "Anguilla", "Antigua and Barbuda", "Aruba", "Barbados", "Bermuda", "Bolivia", "Brazil: Boa Vista, Campo Grande, Manaus", "Canada ('Atlantic Time'): Labrador, New Brunswick, Nova Scotia, Prince Edward Island, eastern Quebec", "Chile", "Dominica", "Dominican Republic", "Falkland Islands", "Greenland (west)", "Grenada", "Guadeloupe", "Guyana", "Martinique", "Montserrat", "Netherlands Antilles", "Paraguay", "Puerto Rico", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Trinidad and Tobago", "U.S. Virgin Islands" ],

        "GMT-4:30" => [ "Venezuela" ],

        "GMT-5" => [ "Bahamas", "Brazil: Acre_(Brazil)|Acre", "Canada ('Eastern Time'): Nunavut, most of Ontario, most of Quebec", "Cayman Islands", "Colombia", "Cuba", "Ecuador", "Haiti", "Jamaica", "Navassa Island", "Panama", "Peru", "Turks and Caicos Islands", "United States of America ('Eastern Time'): Maine, New Hampshire, Vermont, New York (state)|New York, Massachusetts, Connecticut, Rhode Island, Michigan except extreme northwestern counties, Indiana except the southwest and northwest corners, Ohio, Pennsylvania, New Jersey, eastern Kentucky, West Virginia, Virginia, Washington, D.C., Maryland, Delaware (state)|Delaware, eastern Tennessee, North Carolina, Georgia (state)|Georgia, South Carolina, Florida except western part of panhandle." ],

        "GMT-6" => [ "Belize", "Canada ('Central Time'): Manitoba, Saskatchewan except for Lloydminster, north-western Ontario", "Costa Rica", "Easter Island", "El Salvador", "Galapagos Islands", "Guatemala", "Honduras", "Mexico", "Nicaragua", "United States of America ('Central Time'): Wisconsin, Illinois, the southwest and northwest corners of Indiana, western Kentucky, western and middle Tennessee, Mississippi, Alabama, Minnesota, Iowa, Missouri, Arkansas, Louisiana, north and east North Dakota, eastern South Dakota, middle and eastern Nebraska, most of Kansas, Oklahoma, most of Texas, part of western Florida (panhandle)." ],

        "GMT-7" => [ "Canada ('Mountain Time'): Alberta, small eastern portion of British Columbia, the Saskatchewan side of Lloydminster", "Mexico: Baja California Sur, Chihuahua, Nayarit, Sinaloa, Sonora", "United States of America ('Mountain Time'): southwest North Dakota, western South Dakota, western Nebraska, a sliver of Kansas, Montana, a sliver of Oregon, southern Idaho, Wyoming, Utah, Colorado, Arizona, New Mexico, the El Paso area in Texas" ],

        "GMT-8" => [ "Canada ('Pacific Time'): most of British Columbia, Yukon", "Clipperton Island", "Mexico: Baja California (state)|Baja California Norte", "Pitcairn Islands", "United States of America ('Pacific Time'): Washington (state)|Washington, northern Idaho, most of Oregon, California, Nevada" ],

        "GMT-9" => [ "French Polynesia: Gambier Islands", "United States of America: most of Alaska" ],

        "GMT-9:30" => [ "French Polynesia: Marquesa Islands" ],

        "GMT-10" => [ "Cook Islands", "French Polynesia: Society Islands, Tuamotu Islands, Austral Islands", "Johnston Atoll", "Tokelau", "United States of America: Hawaii, and Aleutian Islands in Alaska" ],

        "GMT-11" => [ "American Samoa", "Jarvis Island, Kingman Reef, Palmyra Atoll", "Midway Islands", "Niue" ],

        "GMT-12" => [ "Baker Island", "Howland Island" ]
      }



    end

  end

  
end
