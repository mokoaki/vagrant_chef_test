%w{mariadb mariadb-server}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

service 'mariadb' do
  action [:enable, :start]
end
