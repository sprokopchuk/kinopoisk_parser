require 'nokogiri'
require 'httpclient'
require 'kinopoisk/movie'
require 'kinopoisk/search'
require 'kinopoisk/person'

module Kinopoisk
  SEARCH_URL = 'http://www.kinopoisk.ru/index.php?kp_query='

  NotFound = Class.new StandardError
  Denied   = Class.new StandardError

  # Headers are needed to mimic proper request so kinopoisk won't block it
  def self.fetch(url)
    HTTPClient.new.get url, nil, { 'User-Agent'=>'a', 'Accept-Encoding'=>'a' }
  end

  # Returns a nokogiri document or an error if fetch response status is not 200
  def self.parse(url)
    page = fetch url
    if page.status == 200
      Nokogiri::HTML(page.body.encode('utf-8'))
    else
      raise NotFound, 'Page not found'
    end
  end
end
