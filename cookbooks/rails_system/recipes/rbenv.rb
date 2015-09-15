target_version = node['rbenv']['version']

%w{gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel}.each do |pkg|
  yum_package pkg do
    action :install
  end
end

#本当に要るのか
group "rbenv" do
  action :create
  members "vagrant"
  append true
end

git '/usr/local/rbenv' do
  repository 'https://github.com/sstephenson/rbenv.git'
  # reference 'master'
  user 'root'
  group 'root'
  action :sync
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

git '/usr/local/rbenv/plugins/ruby-build' do
  repository 'https://github.com/sstephenson/ruby-build.git'
  # reference 'master'
  user 'root'
  group 'root'
  action :sync
end

template "/etc/profile.d/rbenv.sh" do
  path "/etc/profile.d/rbenv.sh"
  owner "root"
  group "root"
  mode "0644"
  source "rbenv.sh.erb"
end

execute "rbenv install #{target_version}" do
  # user   "vagrant"
  # cwd    "/home/vagrant"
  command   "source /etc/profile.d/rbenv.sh; CONFIGURE_OPTS=--disable-install-rdoc rbenv install #{target_version} -v"
  action :run
  not_if { ::File.exists? "/usr/local/rbenv/versions/#{target_version}" }
end

execute "rbnev global #{target_version}" do
  not_if "source /etc/profile.d/rbenv.sh; rbenv global #{target_version}"
  command "source /etc/profile.d/rbenv.sh; rbenv global #{target_version}; rbenv rehash"
end
