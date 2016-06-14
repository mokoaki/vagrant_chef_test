# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_sample_session'

Rails.application.config.session_store :redis_store, servers: { path: '/tmp/redis.sock',
                                                                db: 0,
                                                                namespace: 'vagrant_test_session'
                                                               }, expires_in: 1.days
