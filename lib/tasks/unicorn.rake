namespace :unicorn do
  #Start unicorn
  task :start do
    should_unicorn_is_not_running
    rails_environment = ENV['RAILS_ENV'] || 'development'
    sh "bundle exec unicorn_rails -D -c #{unicorn_config_file_path} -E #{rails_environment}"
  end

  #Stop unicorn
  task :stop do
    should_unicorn_is_running
    unicorn_signal :QUIT
  end

  #Restart unicorn with USR2
  task :restart do
    should_unicorn_is_running
    unicorn_signal :USR2
  end

  #Increment number of worker processes
  task :increment do
    should_unicorn_is_running
    unicorn_signal :TTIN
  end

  #Decrement number of worker processes
  task :decrement do
    should_unicorn_is_running
    unicorn_signal :TTOU
  end

  #Unicorn pstree (depends on pstree command)"
  task :pstree do
    should_unicorn_is_running
    sh "pstree '#{unicorn_pid}'"
  end

  # Helpers

  def unicorn_signal(signal)
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    File.read(unicorn_pid_file_path).to_i
  end

  # unicornが起動してるはずだよね？
  def should_unicorn_is_running
    check_unicorn_process_and_pid_file_delete

    unless unicorn_pid_file_exists?
      puts "Unicorn doesn't seem to be running"
      exit false
    end
  end

  # unicornは起動していないはずだよね？
  def should_unicorn_is_not_running
    check_unicorn_process_and_pid_file_delete

    if unicorn_pid_file_exists?
      puts 'Unicorn seem to be running'
      exit false
    end
  end

  def check_unicorn_process_and_pid_file_delete
    # プロセスが起動していないのにpidファイルがある・・だと？
    if unicorn_pid_file_exists? && !check_unicorn_alive?
      File.delete(unicorn_pid_file_path)
    end
  end

  def unicorn_pid_file_path
    File.join(rails_root, 'tmp/pids/unicorn.pid')
  end

  def unicorn_pid_file_exists?
    File.exist?(unicorn_pid_file_path)
  end

  def unicorn_config_file_path
    File.join(rails_root, 'config/unicorn.rb')
  end

  def unicorn_config_file_exists?
    File.exist?(unicorn_config_file_path)
  end

  def check_unicorn_alive?
    !!(`ps -ef | grep "unicorn_rails master" | grep -v grep` =~ /unicorn_rails master/)
  end

  def rails_root
    require "pathname"
    Pathname.new(__FILE__) + '../../../'
  end
end
