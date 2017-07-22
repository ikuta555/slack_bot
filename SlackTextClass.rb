# slack_text.rb
require 'http'
require 'json'
require 'faye/websocket'
require 'eventmachine'
require 'open-uri'
require 'nokogiri'

class SlackText

  SAYING_URL = 'http://atsume.goo.ne.jp/HxLFhNn4N7Zb'
  API_URL = 'https://slack.com/api/chat.postMessage'

  def initialize(type)
    @type = type
    text
  end

  def text
    case @type
    when 'user_typing' then
      aori
    when 'message' then
      saying(77)
    else
      0
    end
  end

  def aori
    0
  end

  def saying(index)
    html = open(SAYING_URL).read
    nokogiri = Nokogiri::HTML.parse(html)
    data = nokogiri.xpath("//*[@id=\"atsumeWrapper\"]/div[3]/div[#{index}]")
    dialogue = data.xpath('./p').text
    great_mans_name = data.xpath('./h2').text
    "それはそうと、こちらの名言をご覧ください。\n\n>" + dialogue + "\n>\n>-  " + great_mans_name + "  -\n>"
  end
end


