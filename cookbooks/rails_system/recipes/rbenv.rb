target_version = node['rbenv']['ruby']['version']

%w[ gcc bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel ].each do |pkg|
  package pkg do
    action :upgrade
  end
end

git '/home/vagrant/.rbenv' do
  repository 'https://github.com/sstephenson/rbenv.git'
  revision   'master'
  user       'vagrant'
  group      'vagrant'
  action     :sync
end

directory '/home/vagrant/.rbenv/plugins' do
  owner  'vagrant'
  group  'vagrant'
  action :create
  not_if { ::File.exists? '/home/vagrant/.rbenv/plugins/' }
end

git '/home/vagrant/.rbenv/plugins/ruby-build' do
  repository 'https://github.com/sstephenson/ruby-build.git'
  revision   'master'
  user       'vagrant'
  group      'vagrant'
  action     :sync
end

template '/etc/profile.d/rbenv.sh' do
  owner  'vagrant'
  group  'vagrant'
  mode '0644'
  source 'rbenv.sh.erb'
  not_if { ::File.exists? '/etc/profile.d/rbenv.sh' }
end

bash "rbenv install #{target_version}" do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    CONFIGURE_OPTS="--disable-install-rdoc" MAKE_OPTS="-j 2" rbenv install #{target_version} -v
    rbenv global #{target_version}
  EOH

  not_if { ::File.exists? "/home/vagrant/.rbenv/versions/#{target_version}/" }
end

bash 'gem update --system --no-document' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    rbenv exec gem update --system --no-document
  EOH
end

bash 'gem update bundler' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    rbenv exec gem update bundler --no-document
  EOH

  only_if 'source /etc/profile.d/rbenv.sh; gem list | grep bundler'
end

bash 'gem install bundler' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    rbenv exec gem install bundler --no-document
  EOH

  not_if 'source /etc/profile.d/rbenv.sh; gem list | grep bundler'
end
