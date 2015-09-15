yum_package "yum-fastestmirror" do
  action :install
end

execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

%w{git}.each do |pkg|
  yum_package pkg do
    action :install
  end
end

service 'firewalld' do
  action [:disable, :stop]
end
