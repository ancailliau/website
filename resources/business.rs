mail_agent   Waw::Tools::MailAgent.new(Waw.config.smtp_config)
main         AcmScW::Business::MainServices.new
people       AcmScW::Business::PeopleServices.new
activity     AcmScW::Business::ActivityServices.new
olympiades   AcmScW::Business::OlympiadesServices.new
event        AcmScW::Business::EventServices.new
order        AcmScW::Business::OrderServices.new
