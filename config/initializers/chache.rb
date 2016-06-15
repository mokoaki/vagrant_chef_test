Rails.application.config.cache_store = :redis_store, {
  path: '/tmp/redis.sock',
  namespace: "#{Rails.app_class.parent_name}_cache",
  expires_in: 1.days
}
