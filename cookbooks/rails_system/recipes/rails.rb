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

  not_if 'gem list | grep "bundler ("'
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

  not_if 'gem list | grep "nokogiri ("'
end

bash 'gem update bundler' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    source /etc/profile.d/rbenv.sh
    gem update nokogiri -- --use-system-libraries
  EOH
end
