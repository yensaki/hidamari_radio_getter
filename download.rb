require 'net/http'
require 'uri'
require 'json'

require './parser.rb'

url = "https://lantis-net.com/hidamari/backnumber/radio.html"
hash = Parser.new(url).parse

hash.each do |date, number|
  url = number[:url]
  save_filename = "#{number[:h2]}_#{number[:title]}_#{number[:date]}.mp3"
  puts "ffmpeg -i #{url} -vn #{save_filename}"
  `ffmpeg -i #{url} -vn #{save_filename}`
end
