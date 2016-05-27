rails_root = File.expand_path('../../', __FILE__)

# おまじない http://goo.gl/OpYJ3c
ENV['BUNDLE_GEMFILE'] = rails_root + '/Gemfile'

# CPUコア数と同じか、必要に応じて増やす説  (physicalcpu_max?)
worker_processes 2

# 記載しておけば他のディレクトリでこのファイルを叩けなくなる 無くても大した影響はないかも
working_directory rails_root

# Nginxとプロキシ組む場合
# listen '/vagrant/tmp/sockets/unicorn.sock'

# 開発時
listen 3000

# PIDの保存先
pid File.join(rails_root, 'tmp/pids/unicorn.pid')

# xx秒Railsが反応しなければWorkerをkillしてタイムアウト
timeout 30

# ダウンタイムをなくす
preload_app true

# true
# unicornの設定：再読み込みされる アプリのリロード：されない。アプリはマスタでロード済みのものを使う。アプリをリロードしたければ、SIGUSR2を送って新マスタ&workerを立ち上げる方法をとる。 ダウンタイム：発生しない（マスタのアプリをそのまま使うので、workerがあがった時から処理が可能）
# false
# unicornの設定：再読み込みされる アプリのリロード：される ダウンタイム：発生する。（workerがそれぞれアプリをロードするので、ロード完了まで処理できない）

stdout_path File.join(rails_root, 'log/unicorn.stdout.log')
stderr_path File.join(rails_root, 'log/unicorn.stderr.log')

# 効果なしとの情報
# if GC.respond_to?(:copy_on_write_friendly=)
#   GC.copy_on_write_friendly = true
# end

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "#{server.config[:pid]}.oldbin"

  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
