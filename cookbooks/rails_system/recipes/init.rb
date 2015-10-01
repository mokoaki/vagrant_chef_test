package 'yum-fastestmirror' do
  action :upgrade
end

bash 'yum upgrade -y' do
  code 'yum upgrade -y'
end

%w[ git gcc-c++ ].each do |pkg|
  package pkg do
    action :upgrade
  end
end

%w[ firewalld kdump postfix ].each do |sv|
  service sv do
    action [ :disable, :stop ]
  end
end

# selinuxenabledコマンドの終了ステータスが0(selinuxが有効)の場合だけ実行される
bash 'disable selinux enforcement' do
  code 'setenforce 0'
  not_if 'getenforce | grep Permissive'
end

template '/etc/selinux/config' do
  source 'selinux_config.erb'
  owner 'root'
  group 'root'
  mode '0644'
  not_if 'grep SELINUX=disabled /etc/selinux/config'
end

package 'ntp' do
  action :upgrade
end

template '/etc/ntp.conf' do
  source 'ntp.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  not_if 'grep ntp.nict.jp /etc/ntp.conf'
end

service 'ntpd' do
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
