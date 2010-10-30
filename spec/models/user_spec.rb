require 'spec_helper'

describe User do
  include TestHelper

  context "validations" do
    before(:each) do
      @valid_attributes = { :login => "bob",
        :email => "bob@email.com",
        :password => "pass",
        :password_confirmation => "pass"
      }
    end

    it "should be able to create a user with valid attributes" do
      User.create!(@valid_attributes)
    end

    context "for login" do
      it "should not allow a missing login" do
        User.new(@valid_attributes.merge(:login => nil)).should_not be_valid
      end

      it "should have a length of at least one" do
        User.new(@valid_attributes.merge(:login => "")).should_not be_valid
      end

      it "should not allow a length greater than 20" do
        User.new(@valid_attributes.merge(:login => string_of_length(21))).should_not be_valid
      end
    end
  end
end
