# About waw services
public_pages Waw::Services::PublicPages::WawAccess.load_hierarchy('public')
#public_pages Waw::Services::PublicPages::Controller.new
webserv      Waw::Services::JSONServices.new('/webserv/people' => AcmScW::Controllers::PeopleController.new,
                                             '/webserv/event' => AcmScW::Controllers::EventController.new)
