mail_agent   Waw::Tools::MailAgent.new(Waw.config.smtp_config)
main         AcmScW::Business::MainServices.new
people       AcmScW::Business::PeopleServices.new
event        AcmScW::Business::EventServices.new