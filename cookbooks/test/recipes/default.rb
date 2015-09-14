yum_package "yum-fastestmirror" do
  action :install
end

%w{gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel}.each do |pkg|
  yum_package pkg do
    action :install
  end
end

%w{git}.each do |pkg|
  yum_package pkg do
    action :install
  end
end

execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

# yum_package 'httpd' do
#   action :install
# end
#
# service 'httpd' do
#   action [:enable, :start]
# end

service 'firewalld' do
  action [:disable, :stop]
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

template '.bash_profile' do
  source '.bash_profile.erb'
  path "/home/vagrant/.bash_profile"
  mode '0644'
  owner 'vagrant'
  group 'vagrant'
  not_if "grep rbenv /home/vagrant/.bash_profile"
end

# execute "source ~/.bash_profile" do
#   user   "vagrant"
#   cwd    "/home/vagrant"
#   command   "source ~/.bash_profile"
#   action :run
# end

execute "rbenv install 2.2.3" do
  user   "vagrant"
  cwd    "/home/vagrant"
  command   "source ~/.bash_profile && CONFIGURE_OPTS=--disable-install-rdoc rbenv install 2.2.3 -v"
  # code   "rbenv install -l"
  # command   "ls -al"
  action :run
  not_if { ::File.exists? "/home/vagrant/.rbenv/versions/2.2.3" }
end
