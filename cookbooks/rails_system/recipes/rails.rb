%w[ libxml2 libxslt libxml2-devel libxslt-devel ].each do |pkg|
  package pkg do
    action :upgrade
  end
end

bash 'gem update bundler' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    gem update bundler
  EOH

  only_if 'source /etc/profile.d/rbenv.sh; gem list | grep bundler'
end

bash 'gem install bundler' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    gem install bundler
  EOH

  not_if 'source /etc/profile.d/rbenv.sh; gem list | grep bundler'
end

bash 'rails gem init' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    bundle install
    bundle update
  EOH
end

bash 'rails db init' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    bundle exec rake db:create
    bundle exec rake db:migrate
    bundle exec rake db:seed
  EOH
end
