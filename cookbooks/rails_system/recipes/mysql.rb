template '/etc/yum.repos.d/mariadb.repo' do
  source 'mariadb.repo.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

%w[ MariaDB-server MariaDB-client MariaDB-devel ].each do |pkg|
  package pkg do
    action :upgrade
    options '--enablerepo=mariadb'
  end
end

service 'mariadb' do
  action [ :enable, :start ]
end

template '/etc/my.cnf' do
  source 'my.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart , 'service[mariadb]'
end

template '/etc/my.cnf.d/client.cnf' do
  source 'my.cnf.d.client.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart , 'service[mariadb]'
end

template '/etc/my.cnf.d/mysql-clients.cnf' do
  source 'my.cnf.d.mysql-clients.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart , 'service[mariadb]'
end

template '/etc/my.cnf.d/server.cnf' do
  source 'my.cnf.d.server.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart , 'service[mariadb]'
end

template '/etc/my.cnf.d/tokudb.cnf' do
  source 'my.cnf.d.tokudb.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart , 'service[mariadb]'
end
