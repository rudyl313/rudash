require 'spec_helper'

describe Entry do
  include TestHelper

  context "validations" do
    before(:each) do
      @valid_attributes = {
        :content => "Do the laundry",
        :due_date => Date.today,
        :due_time => Time.now
      }
    end

    it "should be able to create an object with valid attributes" do
      Entry.create!(@valid_attributes)
    end

    context "for content" do
      it "should check for whether content is present" do
        Entry.new(@valid_attributes.merge(:content => nil)).should_not be_valid
      end

      it "should check for whether content is at least length 1" do
        Entry.new(@valid_attributes.merge(:content => "")).should_not be_valid
      end

      it "should check for whether content is over 1000 in length" do
        Entry.new(@valid_attributes.merge(:content => string_of_length(1001))).should_not be_valid
      end
    end

    it "should check for whether due_date is present" do
      Entry.new(@valid_attributes.merge(:due_date => nil)).should_not be_valid
    end
  end
end
