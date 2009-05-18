# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_aglog_session',
  :secret      => '6fc96be03c7213314725b312442aff04cebde72fffdf1db4468d4dd8942a4317757e6ee9102a2040dfd22e905d3fe7001bb1edab977165455ae564badadfbb1d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
