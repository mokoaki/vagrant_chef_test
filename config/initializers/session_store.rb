# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_sample_session'

Rails.application.config.session_store :redis_store, servers: { host: 'localhost',
                                                                port: 6379,
                                                                db: 0,
                                                                namespace: 'session'
                                                               }, expires_in: 1.days
