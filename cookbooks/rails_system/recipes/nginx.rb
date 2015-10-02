template '/etc/yum.repos.d/nginx.repo' do
  source 'nginx.repo.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

package 'nginx' do
  action :upgrade
  options '--enablerepo=nginx'
end

service 'nginx' do
  action [ :enable, :start ]
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[nginx]'
end

template '/etc/nginx/conf.d/sample_app.conf' do
  source 'sample_app.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[nginx]'
end

file '/etc/nginx/conf.d/default.conf' do
  action :delete
  notifies :reload, 'service[nginx]'
end
