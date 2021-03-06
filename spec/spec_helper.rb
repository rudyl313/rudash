# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:each) do
    ActiveRecord::Base.send(:descendants).each do |klass|
      klass.destroy_all unless klass.first.nil?
    end
  end

  config.include(Capybara, :type=> :integration)
end

module TestHelper
  def string_of_length(len)
    str = ""
    len.times { str << "a" }
    str
  end

  def login_admin
    @admin = User.create!(:login => "admin", :email => "admin@email.com", :password => "adminpass",
                         :password_confirmation => "adminpass", :users_permission => "yes")
    visit "/"
    fill_in "user_session[login]", :with => @admin.login
    fill_in "user_session[password]", :with => "adminpass"
    click_button "Login"
  end

  def login_user(user,pass)
    visit "/"
    fill_in "user_session[login]", :with => user.login
    fill_in "user_session[password]", :with => pass
    click_button "Login"
  end
end
