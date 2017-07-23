require 'open-uri'
require 'nokogiri'
require 'MeCab'
require './SayingClass.rb'

# 名詞リストの空データ
nouns_list = Hash.new("no data")
saying = Saying.new
saying.find_by_id(77)

# HTMLの解析結果をtr要素ごとに処理します
trs.each_with_index do |tr, index|
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
