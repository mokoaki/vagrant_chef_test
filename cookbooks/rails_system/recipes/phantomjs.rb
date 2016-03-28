download_path      = node['phantomjs']['download_path']
download_base_name = File.basename(download_path)
download_file_name = File.basename(download_path, node['phantomjs']['extension_name'])

package 'fontconfig-devel' do
  action :upgrade
end

bash 'phantomjs install' do
  user   'vagrant'
  group  'vagrant'
  cwd    '/home/vagrant'

  code <<-EOH
    wget #{download_path}
    tar jxf /home/vagrant/#{download_base_name}
    sudo cp /home/vagrant/#{download_file_name}/bin/phantomjs /usr/bin/
  EOH

  not_if { ::File.exists? "/home/vagrant/#{download_base_name}" }
end
