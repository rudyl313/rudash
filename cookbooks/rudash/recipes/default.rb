#--------------------------------------------------------------------------------
# Basic Software Requirements
#--------------------------------------------------------------------------------
require_recipe "apt"
require_recipe "build-essential"
require_recipe "apache2"
require_recipe "passenger_apache2::mod_rails"
require_recipe "postgresql::rails"

#--------------------------------------------------------------------------------
# Packages
#--------------------------------------------------------------------------------
# For tests (capybara)
package "libxslt1-dev"
package "xinit"
package "x11-xserver-utils"
package "xmonad"
package "firefox"
package "flashplugin-nonfree"
package "zip"

#--------------------------------------------------------------------------------
# Gems
#--------------------------------------------------------------------------------
gem_package "bundler" do
  action :install
end

execute "bundler" do
  command "sudo bundle install ./.bundle"
  cwd "/vagrant"
end

#--------------------------------------------------------------------------------
# Apache
#--------------------------------------------------------------------------------
# Enable modules required for SSL
#apache_module "headers"
#apache_module "ssl"
#apache_module "proxy"
#apache_module "proxy_http"

# Disable the default site and enable our application
execute "disable-default-site" do
  command "sudo a2dissite default"
  notifies :restart, resources(:service => "apache2")
end

web_app "application" do
  template "application.conf.erb"
  notifies :restart, resources(:service => "apache2")
end

#--------------------------------------------------------------------------------
# X config for tests
#--------------------------------------------------------------------------------
# Allow anybody to start X server
cookbook_file "/etc/X11/Xwrapper.config" do
  source "Xwrapper.config"
end

# xinitrc to properly start xmonad
cookbook_file "/home/vagrant/.xinitrc" do
  source "xinitrc"
  owner "vagrant"
  group "vagrant"
  mode "0644"
end

# xorg.conf to make better resolution
cookbook_file "/etc/X11/xorg.conf" do
  source "xorg.conf"
  mode "0644"
end

# Update user bash profile for running tests
cookbook_file "/home/vagrant/.bashrc" do
  source "bashrc"
  mode "0644"
end

cookbook_file "/home/vagrant/.bash_profile" do
  source "bash_profile"
  mode "0644"
end

#--------------------------------------------------------------------------------
# Application Bootstrap
#--------------------------------------------------------------------------------
bash "db-bootstrap" do
  user "vagrant"
  cwd "/vagrant"

  code <<-CODE
rake db:migrate
rake db:test:prepare
CODE
end
