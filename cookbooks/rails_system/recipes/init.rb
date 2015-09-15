yum_package "yum-fastestmirror" do
  action :install
end

execute "yum-update" do
  user "root"
  command "yum -y update"
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

# setenforce 0で一時的にSELinuxを無効化し、
# /etc/selinux/configの作成を通知する
# selinuxenabledコマンドの終了ステータスが0(selinuxが有効)の場合だけ実行される
execute "disable selinux enforcement" do
  only_if "which selinuxenabled && selinuxenabled"
  command "setenforce 0"
  action :run

  # 呼び出す
  notifies :create, "template[/etc/selinux/config]"
end

# 再起動の際もSELinuxの無効状態を維持するために、
# /etc/selinux/configに、設定を記述する
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
  path "/etc/ntp.conf"
  owner "root"
  group "root"
  mode "0644"
end

service 'ntpd' do
  action [:enable, :start]
end
