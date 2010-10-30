require 'spec_helper'

describe "A user managing users" do
  include TestHelper

  before(:each) do
    login_admin
    click_link "Users"
  end

  it "should show existing users" do
    page.should have_content("admin")
  end

  context "creating a new user" do
    before(:each) do
      click_link "New user"
    end

    it "should be able to create a new user" do
      fill_in "user[login]", :with => "other"
      fill_in "user[email]", :with => "other@email.com"
      fill_in "user[password]", :with => "password"
      fill_in "user[password_confirmation]", :with => "password"
      click_button "Create"
      User.find_by_login("other").should_not be_nil
    end

    it "should not be able to create a new user with invalid info" do
      fill_in "user[login]", :with => "other"
      fill_in "user[email]", :with => "other@email.com"
      fill_in "user[password]", :with => "pass"
      fill_in "user[password_confirmation]", :with => "password"
      click_button "Create"
      User.find_by_login("other").should be_nil
    end
  end

  context "with an existing user" do
    before(:each) do
      @other = User.create(:login => "other", :email => "other@email.com", :password => "otherpass", :password_confirmation => "otherpass")
    end

    it "should be able to edit an exiting user" do
      visit edit_user_path(@other)
      fill_in "user[email]",:with => "new@email.com"
      click_button "Update"
      User.find_by_login(@other.login).email.should eql("new@email.com")
    end

    it "should not be able to edit an exiting user with invalid data" do
      visit edit_user_path(@other)
      fill_in "user[email]",:with => ""
      click_button "Update"
      page.should have_content("Email is too short")
      User.find_by_login(@other.login).email.should_not eql("")
    end

    it "should be able to destroy a user" do
      visit users_path
      find(:css, "#destroy_user_#{@other.id}").click
      User.find_by_login(@other.login).should be_nil
    end
  end
end
