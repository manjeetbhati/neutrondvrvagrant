# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'ipaddr'

Vagrant::DEFAULT_SERVER_URL.replace('https://vagrantcloud.com')
vagrant_config = YAML.load_file("vagrant.conf.yml")

use_proxy = !((ENV['http_proxy'].nil? || ENV['http_proxy'].empty?) &&
              (ENV['https_proxy'].nil? || ENV['https_proxy'].empty?))

Vagrant.configure(2) do |config|
  config.vm.box = vagrant_config['box']
  if use_proxy
    if Vagrant.has_plugin?("vagrant-proxyconf")
      config.proxy.http = ENV['http_proxy']
      config.proxy.https = ENV['https_proxy']
      config.proxy.https = ENV['ftp_proxy']
      config.proxy.no_proxy = ENV['no_proxy']
    else
      raise "vagrant-proxyconf (https://github.com/tmatilai/vagrant-proxyconf/) is not installed and proxy being used"
    end
  end
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
  end

  #config.vm.synced_folder
  #config.vm.synced_folder File.expand_path("~/neutron"), "/opt/stack/neutron"
  #config.vm.synced_folder File.expand_path("~/nova"), "/opt/stack/nova"

  # Bring up the Devstack allinone node on Virtualbox
  config.vm.define "allinone", primary: true do |allinone|
    allinone.vm.host_name = vagrant_config['allinone']['host_name']
    #allinone.vm.network "private_network", ip: vagrant_config['allinone']['ip']
    allinone.vm.provision "shell", path: "provisioning/setup-base.sh", privileged: false
    allinone.vm.provision "shell", path: "provisioning/setgerritproxy.sh", privileged: true,
      :args => "#{vagrant_config['proxy']['gproxy']}"
    allinone.vm.provision "shell", path: "provisioning/setup-allinone.sh", privileged: false
    allinone.vm.provider "libvirt" do |vb|
       vb.memory = vagrant_config['allinone']['memory']
       vb.cpus = vagrant_config['allinone']['cpus']
    end
  end

  # Bring up the first Devstack compute node on Virtualbox
  config.vm.define "compute1" do |compute1|
    compute1.vm.host_name = vagrant_config['compute1']['host_name']
    #compute1.vm.network "private_network", ip: vagrant_config['compute1']['ip']
    compute1.vm.provision "shell", path: "provisioning/setup-base.sh", privileged: false
    compute1.vm.provision "shell", path: "provisioning//setgerritproxy.sh", privileged: false,
      :args => "#{vagrant_config['proxy']['gproxy']}"
    compute1.vm.provision "shell", path: "provisioning/setup-compute.sh", privileged: false
    compute1.vm.provider "libvirt" do |vb|
       vb.memory = vagrant_config['compute1']['memory']
       vb.cpus = vagrant_config['compute1']['cpus']
    end
  end

  # Bring up the network node on Virtualbox enabled also as
  config.vm.define "network" do |network|
    network.vm.host_name = vagrant_config['network']['host_name']
    #network.vm.network "private_network", ip: vagrant_config['network']['ip']
    network.vm.provision "shell", path: "provisioning/setup-base.sh", privileged: false
    network.vm.provision "shell", path: "provisioning//setgerritproxy.sh", privileged: false,
      :args => "#{vagrant_config['proxy']['gproxy']}"
    network.vm.provision "shell", path: "provisioning/setup-network.sh", privileged: false
    network.vm.provider "libvirt" do |vb|
       vb.memory = vagrant_config['network']['memory']
       vb.cpus = vagrant_config['network']['cpus']
    end
  end
  # Execute sudo nova-manage cell_v2 discover_hosts --verbose in the allinone
  # node after the entire cluster is up
end
