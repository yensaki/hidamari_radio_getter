require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'
require 'pry'

class HoneyParser
  def initialize(url)
    @url = url
  end

  def parse
    uri = URI.parse @url

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    res = https.start {
      https.get(uri.request_uri, {'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36"})
    }

    if res.code == '200'
      doc = Nokogiri::HTML.parse(res.body, nil, nil)
      array = []
      doc.xpath("//a").each do |node|
        url = node.attributes["href"].value
        if url.match(/\.m3u8$/)
          array << url
        end
      end
      array
    else
      raise
    end
  end
end
