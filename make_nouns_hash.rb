require 'open-uri'
require 'nokogiri'
require 'MeCab'
require './SayingClass.rb'

# 名言をとってくるURL
url = "http://atsume.goo.ne.jp/HxLFhNn4N7Zb"
html = open(url).read

# NokogiriとXPathでスクレイピング
xpath = "//*[@id=\"atsumeWrapper\"]/div[3]/div"
doc = Nokogiri::HTML.parse(html)
trs = doc.xpath(xpath)

# 名詞リストの空データ
nouns_list = Hash.new("no data")

# HTMLの解析結果をtr要素ごとに処理します
trs.each_with_index do |tr, index|
  word = tr.xpath('./p').text
  grate = tr.xpath('./h2').text
  saying = Saying.new(word, grate)
  nouns = saying.parse_noun

  # データがないときには新しく作る
  # 既にkeyが一致するデータがあればindexの情報を追加
  nouns.each do |noun|
    if nouns_list[noun] == "no data" then
      nouns_list[noun] = [index]
    else
      nouns_list[noun].push(index)
    end
  end
end

nouns_list
