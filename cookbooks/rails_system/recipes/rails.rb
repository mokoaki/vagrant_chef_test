%w[ libxml2 libxslt libxml2-devel libxslt-devel ].each do |pkg|
  package pkg do
    action :upgrade
  end
end

bash 'gem install bundler' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    gem install bundler
  EOH

  # not_if 'gem list | grep "bundler ("'
end

bash 'gem update bundler' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    gem update bundler
  EOH
end

bash 'gem install nokogiri' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    gem install nokogiri -- --use-system-libraries
  EOH

  # not_if 'gem list | grep "nokogiri ("'
end

bash 'gem update nokogiri' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    gem update nokogiri -- --use-system-libraries
  EOH
end

bash 'rails init' do
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

  # not_if 'ps -aux | grep "unicorn_rails master"'
end
