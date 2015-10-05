#CPUコア数と同じ説
#CPUコア数と同じか、必要に応じて増やす説
worker_processes 2

#Nginxとプロキシ組む場合
# listen '/vagrant/tmp/sockets/unicorn.sock'

#開発時
listen 3000

pid 'tmp/pids/unicorn.pid'

#15秒Railsが反応しなければWorkerをkillしてタイムアウト
timeout 15

#ダウンタイムをなくす
preload_app true

#true
#unicornの設定：再読み込みされる アプリのリロード：されない。アプリはマスタでロード済みのものを使う。アプリをリロードしたければ、SIGUSR2を送って新マスタ&workerを立ち上げる方法をとる。 ダウンタイム：発生しない（マスタのアプリをそのまま使うので、workerがあがった時から処理が可能）

#false
#unicornの設定：再読み込みされる アプリのリロード：される ダウンタイム：発生する。（workerがそれぞれアプリをロードするので、ロード完了まで処理できない）

stdout_path 'log/unicorn.stdout.log'
stderr_path 'log/unicorn.stderr.log'

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      #古いマスターがいたら死んでもらう
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
