template "/etc/yum.repos.d/nginx.repo" do
  source "nginx.repo.erb"
  owner "root"
  group "root"
  mode "0644"
end

yum_package "nginx" do
  action :install
  options "--enablerepo=nginx"
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

# とりあえずRailsを用意しないと動かなくなるのでコメントアウト
# template "/etc/nginx/conf.d/nginx_testapp.conf" do
#   source "nginx_testapp.conf.erb"
#   owner "root"
#   group "root"
#   mode "0644"
# end
#
# file "/etc/nginx/conf.d/default.conf" do
#   action :delete
# end

service "nginx" do
  action [:enable, :restart]
end
