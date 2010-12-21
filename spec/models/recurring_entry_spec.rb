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

  context "scopes" do
    it "should be able to find all recurring daily recurring entries" do
      re1 = Factory.create(:recurring_entry,:period => "daily")
      re2 = Factory.create(:recurring_entry,:period => "weekly")
      RecurringEntry.daily.should include(re1)
      RecurringEntry.daily.should_not include(re2)
    end

    it "should be able to find weekly recurring entries matching a specific date range" do
      dates = ((Date.today)..(Date.today+2.days)).to_a
      re1 = Factory.create(:recurring_entry,:period => "weekly", :wday => Date.today.wday)
      re2 = Factory.create(:recurring_entry,:period => "weekly",
                           :wday => (Date.today-1.day).wday)
      RecurringEntry.weekly(dates).should include(re1)
      RecurringEntry.weekly(dates).should_not include(re2)
    end

    it "should be able to find monthly recurring entries matching a specific date range" do
      dates = ((Date.today)..(Date.today+2.days)).to_a
      re1 = Factory.create(:recurring_entry,:period => "monthly", :mday => Date.today.mday)
      re2 = Factory.create(:recurring_entry,:period => "monthly",
                           :mday => (Date.today-1.day).mday)
      RecurringEntry.monthly(dates).should include(re1)
      RecurringEntry.monthly(dates).should_not include(re2)
    end

    it "should be able to find yearly recurring entries matching a specific date range" do
      dates = ((Date.today)..(Date.today+2.days)).to_a
      re1 = Factory.create(:recurring_entry,:period => "yearly", :mday => Date.today.mday,
                           :month => Date.today.month)
      re2 = Factory.create(:recurring_entry,:period => "yearly",
                           :mday => (Date.today - 1.day).mday,
                           :month => (Date.today - 1.day).month)
      RecurringEntry.yearly(dates).should include(re1)
      RecurringEntry.yearly(dates).should_not include(re2)
    end

    it "should be able to find recurring entries for a specific user" do
      user = Factory.create(:user)
      re1 = Factory.create(:recurring_entry, :user => user)
      re2 = Factory.create(:recurring_entry)
      RecurringEntry.for_user(user).should include(re1)
      RecurringEntry.for_user(user).should_not include(re2)
    end
  end

  context "generating entries" do
    it "should generate daily entries every day without duplicating" do
      dates = [Date.today, Date.today + 1.day]
      user = Factory.create(:user)
      Factory.create(:recurring_entry,:period => "daily", :content => "Daily",
                     :user_id => user.id)
      user.entries.length.should == 0
      RecurringEntry.generate_entries(dates,user)
      user.reload.entries.length.should == 2
      RecurringEntry.generate_entries(dates,user)
      user.reload.entries.length.should == 2
    end

    it "should generate weekly entries for a date range without duplicating" do
      dates = [Date.today, Date.today + 1.day]
      user = Factory.create(:user)
      Factory.create(:recurring_entry,:period => "weekly", :content => "Weekly",
                     :user_id => user.id, :wday => Date.today.wday)
      user.entries.length.should == 0
      RecurringEntry.generate_entries(dates,user)
      user.reload.entries.length.should == 1
      user.reload.entries.first.due_date.should == Date.today
      RecurringEntry.generate_entries(dates,user)
      user.reload.entries.length.should == 1
    end

    it "should generate monthly entries for a date range without duplicating" do
      dates = [Date.today, Date.today + 1.day]
      user = Factory.create(:user)
      Factory.create(:recurring_entry,:period => "monthly", :content => "Monthly",
                     :user_id => user.id, :mday => Date.today.mday)
      user.entries.length.should == 0
      RecurringEntry.generate_entries(dates,user)
      user.reload.entries.length.should == 1
      user.reload.entries.first.due_date.should == Date.today
      RecurringEntry.generate_entries(dates,user)
      user.reload.entries.length.should == 1
    end

    it "should generate yearly entries for a date range without duplicating" do
      dates = [Date.today, Date.today + 1.day]
      user = Factory.create(:user)
      Factory.create(:recurring_entry,:period => "yearly", :content => "Yearly",
                     :user_id => user.id, :mday => Date.today.mday,
                     :month => Date.today.month)
      user.entries.length.should == 0
      RecurringEntry.generate_entries(dates,user)
      user.reload.entries.length.should == 1
      user.reload.entries.first.due_date.should == Date.today
      RecurringEntry.generate_entries(dates,user)
      user.reload.entries.length.should == 1
    end
  end

  context "updating entries" do
    it "should be able to create a new entry" do
      user = Factory.create(:user)
      re = Factory.create(:recurring_entry, :user_id => user.id)
      RecurringEntry.update_entry(re,Date.today)
      user.reload.entries.length.should == 1
      user.reload.entries.first.content.should == re.content
    end

    it "should be able to update an existing entry" do
      user = Factory.create(:user)
      re = Factory.create(:recurring_entry, :user_id => user.id)
      RecurringEntry.update_entry(re,Date.today)
      re.content = "New content"
      re.save!
      RecurringEntry.update_entry(re,Date.today)
      user.reload.entries.length.should == 1
      user.reload.entries.first.content.should == "New content"
    end
  end
end
