# About waw services
public_pages Waw::Services::PublicPages.new
people       Waw::Services::JSONServices.new('/webserv/people' => AcmScW::Controllers::PeopleController.new)
