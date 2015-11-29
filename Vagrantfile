# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'chef/bento/centos-7.1'
  config.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.1_chef-provisionerless.box'

  config.vm.hostname = 'vagrant-chef-rails-test-vm'

  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = './cookbooks'

    chef.json = {
      rbenv: {
        ruby: {
          version: '2.2.3',
        },
      },
      git: {
        setting: {
          user: 'mokoaki',
          email: 'mokoriso@gmail.com',
        },
      },
    }

    chef.run_list = [
      'recipe[rails_system::init]',
      'recipe[rails_system::mysql]',
      'recipe[rails_system::redis]',
      'recipe[rails_system::rbenv]',
      'recipe[rails_system::rails]',
    ]
  end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network 'private_network', ip: '192.168.56.11'

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder './', '/vagrant', type: 'nfs'

  config.vm.provider 'virtualbox' do |vb|
    host = RbConfig::CONFIG['host_os']

    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
      # elsif host =~ /linux/
      #   cpus = `nproc`.to_i
      #   mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
      # else # Windows
      #   cpus = 2
      #   mem = 1024
    end

    vb.name = 'vagrant-chef-rails-test-vm'
    vb.gui = false
    vb.memory = mem
    vb.cpus   = cpus
  end
end
