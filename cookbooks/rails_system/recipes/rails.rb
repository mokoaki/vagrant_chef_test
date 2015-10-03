%w[ libxml2 libxslt libxml2-devel libxslt-devel ].each do |pkg|
  package pkg do
    action :upgrade
  end
end

node['rbenv']['ruby']['default_gems'].each do |gem|
  bash "gem install #{gem['name']}" do
    user   'vagrant'
    group  'vagrant'
    cwd    '/home/vagrant'

    code <<-EOH
      source /etc/profile.d/rbenv.sh
      gem install #{gem['name']} #{gem['options']}
    EOH

    not_if "source /etc/profile.d/rbenv.sh; gem list | grep #{gem['name']}"
  end

  bash "gem update #{gem['name']}" do
    user   'vagrant'
    group  'vagrant'
    cwd    '/home/vagrant'

    code <<-EOH
      source /etc/profile.d/rbenv.sh
      gem update #{gem['name']} #{gem['options']}
    EOH
  end
end

bash 'rails db init' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    bundle install
    bundle exec rake db:create
    bundle exec rake db:migrate
    bundle exec rake db:seed
  EOH
end

bash 'rails unicorn start' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    bundle exec rake unicorn:start
  EOH

  not_if 'ps -aux | grep "unicorn_rails master" | grep -v grep'
end
