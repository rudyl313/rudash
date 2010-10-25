define :gem_binaries do
  #--------------------------------------------------------------------------------
  # Gems with binaries
  #--------------------------------------------------------------------------------
  # Install bundler
  gem_package "bundler" do
    action :install
  end
end
