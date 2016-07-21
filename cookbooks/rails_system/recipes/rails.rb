# fontconfig-devel: phantomjs用
%w[ fontconfig-devel ].each do |pkg|
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
    rbenv exec gem update bundler --no-document
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
    bin/rails db:create
    bin/rails db:migrate
    bin/rails db:seed
  EOH
end
