package 'redis' do
  action :upgrade
  options '--enablerepo=remi'
end

service 'redis' do
  action [ :enable, :start ]
end

template '/etc/redis.conf' do
  source 'redis.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart , 'service[redis]'
end
