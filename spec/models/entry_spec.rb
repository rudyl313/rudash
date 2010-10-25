require 'spec_helper'

describe Entry do
  context "validations" do
    before(:each) do
      @valid_attributes = {
        :content => "Do the laundry",
        :due_date => Date.today,
        :due_time => Time.now
      }
    end

    it "should check for whether content is present" do
      Entry.new(@valid_attributes.merge(:content => "")).should_not be_valid
    end

    it "should check for whether due_date is present" do
      Entry.new(@valid_attributes.merge(:due_date => nil)).should_not be_valid
    end
  end
end
