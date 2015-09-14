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

#本当に要るのか
group "rbenv" do
  action :create
  members "vagrant"
  append true
end

git '/usr/local/rbenv' do
  repository 'https://github.com/sstephenson/rbenv.git'
  reference 'master'
  user 'root'
  group 'root'
  action :checkout
end

directory "/usr/local/rbenv/shims" do
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

directory "/usr/local/rbenv/versions" do
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

directory "/usr/local/rbenv/plugins" do
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

template "/etc/profile.d/rbenv.sh" do
  path "/etc/profile.d/rbenv.sh"
  owner "root"
  group "root"
  mode "0644"
  source "rbenv.sh.erb"
end

git '/usr/local/rbenv/plugins/ruby-build' do
  repository 'https://github.com/sstephenson/ruby-build.git'
  reference 'master'
  user 'root'
  group 'root'
  action :checkout
end

execute "rbenv install 2.2.3" do
  # user   "vagrant"
  # cwd    "/home/vagrant"
  command   "source /etc/profile.d/rbenv.sh; CONFIGURE_OPTS=--disable-install-rdoc rbenv install 2.2.3 -v"
  action :run
  not_if { ::File.exists? "/usr/local/rbenv/versions/2.2.3" }
end

execute 'rbnev-global' do
  not_if 'source /etc/profile.d/rbenv.sh; rbenv global 2.2.3'
  command 'source /etc/profile.d/rbenv.sh; rbenv global 2.2.3; rbenv rehash'
end
