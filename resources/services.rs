# About waw services
public_pages Waw::Services::PublicPages.new
webserv      Waw::Services::JSONServices.new('/webserv/people' => AcmScW::Controllers::PeopleController.new,
                                             '/webserv/event' => AcmScW::Controllers::EventController.new)
