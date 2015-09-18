yum_package "yum-fastestmirror" do
  action :install
end

execute "yum update -y" do
  command "yum update -y"
  action :run
end

%w{git ntp}.each do |pkg|
  yum_package pkg do
    action :install
  end
end

%w{firewalld kdump postfix}.each do |svc|
  service svc do
    action [:disable, :stop]
  end
end

# selinuxenabledコマンドの終了ステータスが0(selinuxが有効)の場合だけ実行される
execute "disable selinux enforcement" do
  only_if "which selinuxenabled && selinuxenabled"
  command "setenforce 0"
  action :run

  # 呼び出す
  notifies :create, "template[/etc/selinux/config]"
end

template "/etc/selinux/config" do
  source "selinux_config.erb"
  owner "root"
  group "root"
  mode "0644"

  # 通常は動作しない
  action :nothing
end

template "/etc/ntp.conf" do
  source "ntp.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

service 'ntpd' do
  action [:enable, :start]
end

template "/home/vagrant/.gemrc" do
  source "gemrc.erb"
  owner "vagrant"
  group "vagrant"
  mode "0644"
end

template "/etc/profile.d/alias.sh" do
  owner  "vagrant"
  group  "vagrant"
  mode "0644"
  source "alias.sh.erb"
end

execute "git setting" do
  # user "vagrant"
  # group "vagrant"
  # cwd   "/home/vagrant"

  # rootで実行されるのでとりあえず対応

  command <<-EOH
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
