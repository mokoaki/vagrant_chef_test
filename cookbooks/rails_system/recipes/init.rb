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

service 'firewalld' do
  action [:disable, :stop]
end

template "/etc/ntp.conf" do
  path "/etc/ntp.conf"
  owner "root"
  group "root"
  mode "0644"
  source "ntp.conf.erb"
end

service 'ntpd' do
  action [:enable, :start]
end
