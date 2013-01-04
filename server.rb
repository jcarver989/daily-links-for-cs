require 'rubygems'
require 'bundler/setup'
require 'open-uri'
require 'nokogiri'
require 'sinatra'
require 'gmail'

require './lib/link'
require './lib/datasources'
require './lib/helpers'
require './lib/link_scraper'

@@scraper = LinkScraper.new(30) # cache 30 minutes 

get "/" do 
  erb :index, :locals => { :links => @@scraper.scrape_links } 
end
