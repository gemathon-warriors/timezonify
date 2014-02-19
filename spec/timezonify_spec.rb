require 'spec_helper'

describe "Find timezone where the time is" do

  it "if time is given at GTM return current timezone should be GMT" do
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

end
