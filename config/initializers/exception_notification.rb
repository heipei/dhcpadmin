Dhcpadmin::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[DHCPAdmin ERROR] ",
  :sender_address => 'johannes.gilger@alania.rwth-aachen.de',
  :exception_recipients => ['johannes.gilger@alania.rwth-aachen.de']
