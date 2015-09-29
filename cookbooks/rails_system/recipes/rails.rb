%w{libxml2 libxslt libxml2-devel libxslt-devel}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

execute "gem install bundler" do
  user   "vagrant"
  group  "vagrant"
  cwd    "/home/vagrant"
  command   "source /etc/profile.d/rbenv.sh; gem install bundler"
  action :run
  # not_if { ::File.exists? "/home/vagrant/.rbenv/versions/#{target_version}" }
end

execute "gem install nokogiri" do
  user   "vagrant"
  group  "vagrant"
  cwd    "/home/vagrant"
  command   "source /etc/profile.d/rbenv.sh; gem install nokogiri -- --use-system-libraries"
  action :run
  # not_if { ::File.exists? "/home/vagrant/.rbenv/versions/#{target_version}" }
end
