# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.box = "precise32"

  config.vm.network :forwarded_port, guest: 80, host: 8080    # nginx
  config.vm.network :forwarded_port, guest: 9200, host: 9200  # elasticsearch
  config.vm.network :forwarded_port, guest: 6379, host: 6379  # redis

  config.vm.synced_folder "configs", "/home/vagrant/configs"

  config.vm.provision :shell,
    :inline => "/vagrant/setup.sh"

end
