require 'spec_helper'

describe "Find timezone where the time is" do

  it "if time is given at GMT return current timezone should be GMT" do
    offset = Timezonify::Timezone.timezone_for_time(Time.now.utc)
    offset.should == 'GMT'
  end

  it "if time is given at IST return current timezone should be GMT+05:30" do
    offset = Timezonify::Timezone.timezone_for_time(Time.now.utc+5.hours+30.minutes)
    offset.should == 'GMT+05:30'
  end

  it "if time is given at EST return current timezone should be GMT-05:00" do
    offset = Timezonify::Timezone.timezone_for_time(Time.now.utc-5.hours)
    offset.should == 'GMT-05'
  end

  it "should return local machine timezone" do
    zone = Timezonify::Timezone.local_zone
    zone.should == 'GMT'
  end

  describe "TimeHelper" do
    it "should return time in hours when time is in complete hour" do
      time = Time.parse('8:00 AM')
      Timezonify::TimeHelper.time_in_hours(time).should == 8.0
    end
    it "should return time in hours when time is with 30 mins past a complete hour" do
      time = Time.parse('5:30 AM')
      Timezonify::TimeHelper.time_in_hours(time).should == 5.5
    end
  end

  describe "TimeZoneHelper" do
    it "should return all timezones with the given offset" do
      # IST
      time_in_hours = 5.5
      expected_results = ActiveSupport::TimeZone.all.select{|tz| tz.utc_offset == time_in_hours * 3600}
      Timezonify::TimezoneHelper.find_all_timezones_with_offset(time_in_hours).should == expected_results
    end
  end

end
