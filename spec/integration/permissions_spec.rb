require 'spec_helper'

describe "users navigating the site" do
  include TestHelper

  before(:each) do
    @user_attributes = { :login => "login", :email => "login@email.com",
      :password => "passwer", :password_confirmation => "passwer" }
  end

  it "should be able to view users if it has the users_permission" do
    user = User.create(@user_attributes.merge(:users_permission => "yes"))
    login_user(user,@user_attributes[:password])
    page.should have_content("Users")
    visit users_path
    current_path.should == users_path
  end

  it "should not be able to view users if it does have the users_permission" do
    user = User.create(@user_attributes)
    login_user(user,@user_attributes[:password])
    page.should_not have_content("Users")
    visit users_path
    current_path.should_not == users_path
  end

end
