#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'
require 'highline'

class WebVisitor
  
  # The root uri
  attr_reader :root_uri
  
  # The mechanize agent
  attr_reader :agent
  
  # Seen URIs
  attr_reader :seen
  
  # Highline
  attr_reader :highline
  
  # Creates a visitor instance
  def initialize(root_uri)
    @root_uri = URI::parse(root_uri)
    @agent = Mechanize.new
    @seen = {}
    @highline = HighLine.new
  end
  
  # Visits the web site
  def visit
    check(agent.get(root_uri))
  end
  
  # Checks a page
  def check(page)
    return if seen.has_key?(page.uri)
    seen[page.uri] = true
    
    errors = []
    page.links.each do |link|
      next unless link.href
      next if link.uri.scheme == 'mailto'
      next if link.uri.host && link.uri.host != root_uri.host
      next if seen.has_key? URI::parse(agent.send(:resolve, link.uri, page))
      
      begin
        got = link.click

        # Recurse if a page on the same website
        if (Mechanize::Page === got) && 
           (got.uri.host == root_uri.host)
          check(got)
        else
          seen[got.uri] = true
        end

      rescue Mechanize::ResponseCodeError
        errors << "+ lost link #{link.href}"
      rescue Mechanize::UnsupportedSchemeError
        errors << "+ unsupported scheme on #{link.href}"
      end
    end
    
    color = errors.empty? ? :green : :red
    highline.say highline.color("#{page.uri}", color) + " - #{page.title}"
    unless errors.empty?
      highline.say "  " + errors.join("\n  ")
    end
  end
  
end

v = WebVisitor.new(ARGV[0] || 'http://127.0.0.1:9292/')
begin
  v.visit
rescue Interrupt
end
