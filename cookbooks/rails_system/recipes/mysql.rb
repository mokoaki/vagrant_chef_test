%w{mariadb mariadb-server}.each do |pkg|
  yum_package pkg do
    action :install
  end
end

service 'mariadb' do
  action [:enable, :start]
end
