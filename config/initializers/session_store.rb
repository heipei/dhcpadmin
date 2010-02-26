# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_dhcpadmin_session',
  :secret      => 'cff4b6b485ce9316bde9327b35403aef19779af8f5a083ac70a43d392b47a7a3c4630fd4df25ff3f4053822fe7e1debd5b243bd1d54d4244bf50eaa0ac51011e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
