require 'open-uri'
require 'nokogiri'
require 'MeCab'
require './MecabString.rb'

# 名言をとってくるURL
SAYING_URL = 'http://atsume.goo.ne.jp/HxLFhNn4N7Zb'
html = open(SAYING_URL).read

# NokogiriとXPathでスクレイピング
xpath = "//*[@id=\"atsumeWrapper\"]/div[3]/div"
doc = Nokogiri::HTML.parse(html)
div = doc.xpath(xpath)

# 名言のデータはsayingsの中に格納される
# 名言に含まれる名詞のデータはnouns_listの中
sayings = []
nouns_list = Hash.new("NoData")

# HTMLの解析結果をtr要素ごとに処理します
div.each_with_index do |tr, index|
  dialog = tr.xpath('./p').text
  greatman = tr.xpath('./h2').text
  saying_hash = { dialog: dialog, greatman: greatman }
  sayings.push(saying_hash)

  # 名言から名詞を抽出
  saying_nouns = saying_hash[:dialog].parse_noun

  # 名詞データがないときには新しく作る
  # 既にkeyが一致するデータがあればindexの情報を追加
  saying_nouns.each do |noun|
    if nouns_list[noun] == "NoData" then
      nouns_list[noun] = [index]
    else
      nouns_list[noun].push(index)
    end
  end
end

$sayings = sayings
$nouns_list = nouns_list

class Saying
  
  attr_accessor :id, :dialog, :greatman

  # newした時に名言のidを渡す
  def initialize(id)
    @id = id
    saying = $sayings[id]
    @dialog = saying[:dialog]
    @greatman = saying[:greatman]
  end

  # 任意の文字列にかぶった名詞があるかどうか調べて適当なidと名詞をとってくる
  def self.match_data(text)
    match_nouns = []
    $nouns_list.each do |list|
      index = text.include?(list[0]) ? list[1].sample : nil
      match_noun = index ? { noun: list[0], index: index } : nil
      match_nouns.push(match_noun) if match_noun 
    end
    match_nouns.sample
  end 
end
