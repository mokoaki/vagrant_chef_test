%w[ libxml2 libxslt libxml2-devel libxslt-devel fontconfig-devel ].each do |pkg|
  package pkg do
    action :upgrade
  end
end

# fontconfig-devel: phantomjs用

bash 'gem update bundler' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    rbenv exec gem update bundler --no-document
    rbenv rehash
  EOH

  only_if 'source /etc/profile.d/rbenv.sh; gem list | grep bundler'
end

bash 'gem install bundler' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    rbenv exec gem install bundler --no-document
    rbenv rehash
  EOH

  not_if 'source /etc/profile.d/rbenv.sh; gem list | grep bundler'
end

bash 'rails gem init' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    bundle install --jobs=2
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
