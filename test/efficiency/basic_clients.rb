require 'rubygems'
require 'waw'
CLIENTS   = 10
NB_REQUEST = 10
LOCATIONS = %w{index activites latex olympiades scienceinfuse/index scienceinfuse/acces
               scienceinfuse/sponsoring securite-vie-privee/index securite-vie-privee/orateurs
               securite-vie-privee/sponsoring events} 

t1 = Time.now
threads = []
CLIENTS.times do |client|
  threads << Thread.new(client) do 
    browser = Waw::Testing::Browser.new
    browser.location = 'http://127.0.0.1:9292/'
    
    NB_REQUEST.times do
      selected = LOCATIONS[Kernel.rand(LOCATIONS.size)]
      puts "Client #{client} requesting #{selected}"
      browser.location = "/#{selected}"
    end
  end
end
threads.each {|t| t.join}
t2 = Time.now

avg_by_page = (t2-t1).to_f/(CLIENTS*NB_REQUEST).to_f
pages_by_sec = 1.0/avg_by_page
puts "#{CLIENTS*NB_REQUEST} pages requested in #{t2-t1} second, means"
puts "Average time by page: #{avg_by_page}"
puts "Number of pages by second: #{pages_by_sec}"