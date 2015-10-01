template '/etc/yum.repos.d/epel.repo' do
  source 'epel.repo.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

package 'redis' do
  action :upgrade
  options '--enablerepo=epel'
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
