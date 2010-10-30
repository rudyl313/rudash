require 'spec_helper'

describe "user logging in and out" do
  include TestHelper

  before(:each) do
    @user = User.create!(:login => "test", :email => "test@email.com", :password => "password123", :password_confirmation => "password123")
    visit "/"
  end

  it "should be able to login with correct information" do
    fill_in "user_session[login]", :with => @user.login
    fill_in "user_session[password]", :with => "password123"
    click_button "Login"
    page.should have_no_content("Login")
    page.should have_content("To Do List")
  end

  it "should not be able to login with incorrect information" do
    fill_in "user_session[login]", :with => @user.login
    fill_in "user_session[password]", :with => "password"
    click_button "Login"
    page.should have_content("Login")
    page.should have_no_content("To Do List")
  end

  it "should be able to logout after logging in successfully" do
    fill_in "user_session[login]", :with => @user.login
    fill_in "user_session[password]", :with => "password123"
    click_button "Login"
    page.should have_content("To Do List")
    click_link "Logout"
    page.should have_content("Login")
  end
end
