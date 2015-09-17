target_version = node['rbenv']['version']

%w{gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel}.each do |pkg|
  yum_package pkg do
    action :install
  end
end

git "/home/vagrant/.rbenv" do
  repository "https://github.com/sstephenson/rbenv.git"
  revision   "master"
  user       "vagrant"
  group      "vagrant"
  action     :sync
end

directory "/home/vagrant/.rbenv/plugins" do
  owner  "vagrant"
  group  "vagrant"
  action :create
end

git "/home/vagrant/.rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  revision   "master"
  user       "vagrant"
  group      "vagrant"
  action     :sync
end

template "/etc/profile.d/rbenv.sh" do
  path "/etc/profile.d/rbenv.sh"
  owner  "vagrant"
  group  "vagrant"
  mode "0644"
  source "rbenv.sh.erb"
end

execute "rbenv install #{target_version}" do
  user   "vagrant"
  group  "vagrant"
  cwd    "/home/vagrant"
  command   "source /etc/profile.d/rbenv.sh; CONFIGURE_OPTS=--disable-install-rdoc rbenv install #{target_version} -v"
  action :run
  not_if { ::File.exists? "/home/vagrant/.rbenv/versions/#{target_version}" }
end

execute "rbnev global #{target_version}" do
  user   "vagrant"
  group  "vagrant"
  cwd    "/home/vagrant"
  command "source /etc/profile.d/rbenv.sh; rbenv global #{target_version}; rbenv rehash"
  action :run
end

bash "rbenv global 2.2.3" do
  user   "vagrant"
  group  "vagrant"
  cwd    "/home/vagrant"
  code   "source /etc/profile.d/rbenv.sh; rbenv global 2.2.3; rbenv rehash"
  action :run
end

execute "gem update --system" do
  user   "vagrant"
  group  "vagrant"
  cwd    "/home/vagrant"
  command   "source /etc/profile.d/rbenv.sh; gem update --system"
  action :run
  # not_if { ::File.exists? "/home/vagrant/.rbenv/versions/#{target_version}" }
end
