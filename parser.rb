require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'
require 'pry'

class Parser
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
      hash = {}
      doc.xpath("//div[@id='radio']").each do |node|
        title = node.xpath("p").xpath("span[@class='title']").text
        date = node.xpath("p").xpath("span[@class='date']").text
        h2 = node.xpath("h2").text
        url = node.css("a").last.attributes["href"].value

        hash[date] = {title: title, date: date, h2: h2, url: url}
      end
      hash
    else
      raise
    end
  end
end
