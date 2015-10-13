template '/etc/yum.repos.d/mariadb.repo' do
  source 'mariadb.repo.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

%w[ mariadb mariadb-devel mariadb-server mariadb-libs ].each do |pkg|
  package pkg do
    action :upgrade
    options '--enablerepo=mariadb'
  end
end

service 'mysql' do
  action [ :enable, :start ]
end

template '/etc/my.cnf' do
  source 'my.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart , 'service[mysql]'
end

template '/etc/my.cnf.d/client.cnf' do
  source 'my.cnf.d.client.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart , 'service[mysql]'
end

template '/etc/my.cnf.d/mysql-clients.cnf' do
  source 'my.cnf.d.mysql-clients.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart , 'service[mysql]'
end

template '/etc/my.cnf.d/server.cnf' do
  source 'my.cnf.d.server.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart , 'service[mysql]'
end

template '/etc/my.cnf.d/tokudb.cnf' do
  source 'my.cnf.d.tokudb.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart , 'service[mysql]'
end
