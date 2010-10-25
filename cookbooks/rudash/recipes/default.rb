#--------------------------------------------------------------------------------
# Basic Software Requirements
#--------------------------------------------------------------------------------
require_recipe "apt"
require_recipe "build-essential"
require_recipe "apache2"
# TODO add postgres, but beware the opscode recipe it's been broken before
require_recipe "passenger_apache2::mod_rails"

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

# TODO migrant to postgres to emulate heroku prod env
package "sqlite3"
package "libsqlite3-dev"

#--------------------------------------------------------------------------------
# Gems
#--------------------------------------------------------------------------------
gem_binaries #see ../definitions

execute "bundler" do
  command "sudo bundle install ./.bundle"
  cwd "/vagrant"
end

#--------------------------------------------------------------------------------
# Apache
#--------------------------------------------------------------------------------
# Enable modules required for SSL
apache_module "headers"
apache_module "ssl"
apache_module "proxy"
apache_module "proxy_http"

# SSL
# cookbook_file "/etc/ssl/certs/server.crt" do
#   source "server.crt"
#   not_if "test -f /etc/ssl/certs/server.crt"
# end

# cookbook_file "/etc/ssl/private/server.key" do
#   source "server.key"
#   not_if "test -f /etc/ssl/private/server.key"
# end

# Disable the default site and enable our application
execute "disable-default-site" do
  command "sudo a2dissite default"
  notifies :restart, resources(:service => "apache2")
end

web_app "application" do
  template "application.conf.erb"
  notifies :restart, resources(:service => "apache2")
end

# Hosts file to add localhost.zoodles.com
# cookbook_file "/etc/hosts" do
#   source "hosts"
#   mode "0644"
# end

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
rake db:fixtures:load
rake db:test:prepare
CODE

  only_if "cd /vagrant && rake db:version | grep ' 0$'"
end
