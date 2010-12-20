require 'spec_helper'

describe Entry do
  include TestHelper

  context "validations" do
    before(:each) do
      @valid_attributes = {
        :content => "Do the laundry",
        :due_date => Date.today,
        :due_time => Time.now,
        :order_time => Time.now
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

    it "should check for whether the order_time is present" do
      Entry.new(@valid_attributes.merge(:order_time => nil)).should_not be_valid
    end

    it "should check for whether due_date is present" do
      Entry.new(@valid_attributes.merge(:due_date => nil)).should_not be_valid
    end
  end

  it "should be able to generate an order time" do
    timenowstr = Time.now.strftime("%I:%M%p")
    ordertimestr = Entry.generate_order_time
    timenowstr.should == ordertimestr
  end

  context "finding an order time thats after an entry" do
    it "should have the order time be the same as the due time if the entry has a due time" do
      time = Time.now
      entry = Factory.create(:entry, :due_time => time)
      entry.reload
      time = entry.due_time
      order_time = Entry.order_time_to_be_after("blarg",entry.id.to_s,"blerg")
      order_time.should == time
    end
  end
end
