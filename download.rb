require 'net/http'
require 'uri'
require 'json'

require './honey_parser.rb'

urls = [
  # "https://lantis-net.com/hidamari/backnumber/index.html", # x☆☆☆
  "https://lantis-net.com/hidamari/", # ハニカム リメイク
  "https://lantis-net.com/hidamari/index2.html", # 帰ってきたひだまりラジオ
  "https://lantis-net.com/hidamari/indexbu.html", # ひだまり楽屋裏ジオ×ハニカム
  "https://lantis-net.com/hidamari/indexsp.html", # ひだまりラジオ×SP
  "https://lantis-net.com/hidamari/indexre.html", # ひだまりラジオ リメイク
  "https://lantis-net.com/hidamari/indexh.html", # ひだまりラジオ ☆☆☆ 13
  "https://lantis-net.com/hidamari/index365.html", # ひだまりラジオ 365 リメイク
  "https://lantis-net.com/hidamari/indexhoshi.html", # ひだまりラジオ ☆☆☆ リメイク
]

urls.each do |url|
  download_urls = HoneyParser.new(url).parse
  download_urls.each do |download_url|
    puts download_url
    md = download_url.match(%r|http://qt\.web-radio\.biz:1935/lantisnet/mp3:(.+)/|)
    save_filename = md[1]
    puts "ffmpeg -i #{download_url} -vn #{save_filename}"
    `ffmpeg -i #{download_url} -vn #{save_filename}`
  end
end
