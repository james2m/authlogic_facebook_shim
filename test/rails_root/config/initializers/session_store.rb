# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rails_root_session',
  :secret      => '4deb5b6e05377d982fa6ef37582c0be6de39e1473cc99a4a0f32fd61ec735cd9e86276b2c25fc781e7df8cd6afdc819208f7f497a755e217bff75728d05f543b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
