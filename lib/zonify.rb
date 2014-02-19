require "zonify/version"
require 'active_support'

module Zonify
  class Timezone

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

  end
end
