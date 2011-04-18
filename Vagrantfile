Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. For a detailed explanation
  # and listing of configuration options, please view the documentation
  # online.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "base"
  config.vm.network("192.168.34.10")
  config.vm.boot_mode = :gui
  config.vm.customize do |vm|
    vm.name = "Rudash"
    vm.memory_size = 768
  end

  # Share the WWW folder as the main folder for the web VM using NFS
  config.vm.share_folder("v-root", "/vagrant", ".", :nfs => true)

  # Configure to provision with local cookbooks
  config.vm.provision :chef_solo, :run_list => ["recipe[rudash]"] do |chef|
    chef.json.merge!({:pg => { :user => "rudash", :databases => ["rudash_development"]}})
  end
end
