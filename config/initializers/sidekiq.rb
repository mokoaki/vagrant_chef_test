Rails.application.config.active_job.queue_adapter = :sidekiq

# 全てのsidekiqのキュー名のprefix
module Sample
  class Application < Rails::Application
    config.active_job.queue_name_prefix = Rails.app_class.parent_name
  end
end

# namespaceはactive_jobにより勝手につく
Sidekiq.configure_server do |config|
  config.redis = {
    path: '/tmp/redis.sock',
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    path: '/tmp/redis.sock',
  }
end
