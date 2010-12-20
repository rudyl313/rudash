require 'spec_helper'

describe RecurringEntry do
   include TestHelper

  context "validations" do
    before(:each) do
      @valid_attributes = {
        :period => "daily",
        :content => "content"
      }
    end

    it "should be able to create an object with valid attributes" do
      RecurringEntry.create!(@valid_attributes)
    end

    context "for content" do
      it "should check for whether content is present" do
        RecurringEntry.new(@valid_attributes.merge(:content => nil)).should_not be_valid
      end

      it "should check for whether content is at least length 1" do
        RecurringEntry.new(@valid_attributes.merge(:content => "")).should_not be_valid
      end

      it "should check for whether content is over 1000 in length" do
        RecurringEntry.new(@valid_attributes.merge(:content => string_of_length(1001))).should_not be_valid
      end
    end

    it "should only allow period to be one of the predefined strings" do
      ["daily","weekly","monthly","yearly"].each do |period|
        RecurringEntry.new(@valid_attributes.merge(:period => period)).should be_valid
      end
      RecurringEntry.new(@valid_attributes.merge(:period => "bloggedly")).should_not be_valid
    end

  end
end
