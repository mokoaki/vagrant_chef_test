%w[ libxml2 libxslt libxml2-devel libxslt-devel ].each do |pkg|
  package pkg do
    action :upgrade
  end
end

gem_package 'bundler' do
  action :upgrade
end

gem_package 'nokogiri' do
  action :upgrade
  options '-- --use-system-libraries'
end
