package 'yum-fastestmirror' do
  action :upgrade
end

bash 'yum upgrade -y' do
  code 'yum upgrade -y'
end

%w[ git gcc-c++ kernel-devel ].each do |pkg|
  package pkg do
    action :upgrade
  end
end

%w[ firewalld kdump postfix ].each do |sv|
  service sv do
    action [ :disable, :stop ]
  end
end

bash 'remi-repo' do # epelも一緒に入る
  user   'root'
  group  'root'
  cwd    '/root'

  code <<-EOH
    yum localinstall -y http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
  EOH

  not_if { ::File.exists? "/etc/yum.repos.d/remi.repo" }
end

bash 'disable selinux enforcement' do
  code 'setenforce 0'
  not_if 'getenforce | grep Disabled'
end

template '/etc/selinux/config' do
  source 'selinux_config.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

package 'chrony' do
  action :upgrade
end

template '/etc/chrony.conf' do
  source 'chrony.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'chronyd' do
  action [ :enable, :start ]
end

template '/home/vagrant/.gemrc' do
  source 'gemrc.erb'
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
end

template '/etc/profile.d/alias.sh' do
  source 'alias.sh.erb'
  owner  'vagrant'
  group  'vagrant'
  mode '0644'
end

bash 'git setting' do
  code <<-EOH
    su vagrant -l -c 'git config --global user.name "#{node['git']['setting']['user']}"'
    su vagrant -l -c 'git config --global user.email "#{node['git']['setting']['email']}"'
    su vagrant -l -c 'git config --global color.ui true'
    su vagrant -l -c 'git config --global alias.s "status"'
    su vagrant -l -c 'git config --global alias.c "checkout"'
    su vagrant -l -c 'git config --global alias.b "branch"'
    su vagrant -l -c 'git config --global alias.d "diff"'
    su vagrant -l -c 'git config --global alias.l "log --name-status -3"'
  EOH
end
