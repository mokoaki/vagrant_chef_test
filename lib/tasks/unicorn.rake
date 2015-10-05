namespace :unicorn do
  #Start unicorn
  task :start do
    env = ENV['RAILS_ENV'] || 'development'
    sh "bundle exec unicorn_rails -D -c #{unicorn_config_file} -E #{env}"
  end

  #Stop unicorn
  task :stop do
    unicorn_signal :QUIT
  end

  #Restart unicorn with USR2
  task :restart do
    unicorn_signal :USR2
  end

  #Increment number of worker processes
  task :increment do
    unicorn_signal :TTIN
  end

  #Decrement number of worker processes
  task :decrement do
    unicorn_signal :TTOU
  end

  #Unicorn pstree (depends on pstree command)"
  task :pstree do
    sh "pstree '#{unicorn_pid}'"
  end

  # Helpers

  def unicorn_signal(signal)
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    begin
      File.read(File.join(rails_root, 'tmp/pids/unicorn.pid')).to_i
    rescue Errno::ENOENT
      raise "Unicorn doesn't seem to be running"
    end
  end

  def unicorn_config_file
    File.join(rails_root, 'config/unicorn.rb')
  end

  def rails_root
    require "pathname"
    Pathname.new(__FILE__) + '../../../'
  end
end
