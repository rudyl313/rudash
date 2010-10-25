define :setup_selenium, :home_directory => "/home/vagrant", :user => 'vagrant', :group => 'vagrant' do
  # For tests (capybara)
  package "xinit"
  package "x11-xserver-utils"
  package "xmonad"
  package "firefox"

  #--------------------------------------------------------------------------------
  # X config for tests
  #--------------------------------------------------------------------------------
  # Allow anybody to start X server
  cookbook_file "/etc/X11/Xwrapper.config" do
    source "Xwrapper.config"
  end

  # xinitrc to properly start xmonad
  cookbook_file "#{params[:home_directory]}/.xinitrc" do
    source "xinitrc"
    owner params[:user]
    group params[:group] if params[:group]
    mode "0644"
  end

  # xorg.conf to make better resolution
  cookbook_file "/etc/X11/xorg.conf" do
    source "xorg.conf"
    mode "0644"
  end

  # Update user bash profile for running tests
  cookbook_file "#{params[:home_directory]}/.bashrc" do
    source "bashrc"
    mode "0644"
  end

  cookbook_file "#{params[:home_directory]}/.bash_profile" do
    source "bash_profile"
    mode "0644"
  end
end
