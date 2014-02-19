require "zonify/version"
require 'active_support'

module Zonify
  class Timezone

    def self.which_timezone_it_is(time='Time.now.utc')
      offset = find_offset_for_required_time(time.to_s, current_time="#{Time.now.utc.strftime("%I:%M %p UTC")}")

      if offset < 0
        formatted_offset = formatted_negative_offset(offset)
      else
        formatted_offset = formatted_positive_offset(offset)
      end

      formatted_offset

    end
    
    private

    def self.find_offset_for_required_time(required_time='8:00 AM UTC', current_time="#{Time.now.utc.strftime("%I:%M %p UTC")}")
      required_time = Time.parse(required_time)
      current_time = Time.parse(current_time)

      if current_time < required_time
        current_time_in_hours = TimeHelper.time_in_hours(current_time)
        required_time_in_hours = TimeHelper.time_in_hours(required_time)
        offset_in_hours = required_time_in_hours - current_time_in_hours
        offset = offset_in_hours
      else current_time > required_time
        current_time_in_hours = TimeHelper.time_in_hours(current_time)
        required_time_in_hours = TimeHelper.time_in_hours(required_time)
        offset_in_hours = current_time_in_hours - required_time_in_hours
        offset = -offset_in_hours
      end

      offset
    end

    def self.formatted_positive_offset(offset_in_hours)
      return 'GMT' if (offset_in_hours == 0)

      offset_hours = offset_in_hours.to_s.split('.').first.to_i
      offset_minutes = offset_in_hours.to_s.split('.').last.to_i
      if offset_minutes > 0
        if offset_hours < 10
          "GMT+0" + "#{offset_hours}" + ":30"
        else
          "GMT+" + "#{offset_hours}" + ":30"
        end
      else
        if offset_hours < 10
          "GMT+0" + "#{offset_hours}"
        else
          "GMT+" + "#{offset_hours}"
        end
      end
    end

    def self.formatted_negative_offset(negative_offset_in_hours)
      offset_in_hours = negative_offset_in_hours.to_s.split('-').last.to_f
      offset_hours = offset_in_hours.to_s.split('.').first.to_i
      offset_minutes = offset_in_hours.to_s.split('.').last.to_i
      if offset_minutes > 0
        if offset_hours < 10
          "GMT-0" + "#{offset_hours}" + ":30"
        else
          "GMT-" + "#{offset_hours}" + ":30"
        end
      else
        if offset_hours < 10
          "GMT-0" + "#{offset_hours}"
        else
          "GMT-" + "#{offset_hours}"
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
