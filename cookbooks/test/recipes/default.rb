yum_package "yum-fastestmirror" do
  action :install
end

%w{gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel}.each do |pkg|
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
