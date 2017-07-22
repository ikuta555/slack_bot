require 'MeCab'

class Saying
  attr_reader :word, :grate

  def initialize(word, grate)
    @word = word
    @grate = grate
  end

  def parse_noun  
    
    model = MeCab::Model.new(ARGV.join(" "))
    tagger = model.createTagger()
  
    # puts tagger.parse(@word)
  
    node = tagger.parseToNode(@word)
  
    nouns = []
    while node
      # print node.surface, "\t", node.feature, "\t", node.cost, "\n"   # debug
      target_node = node.feature.force_encoding("UTF-8")
      # 名詞を抽出する
      if /^名詞,一般/ =~ target_node || /^名詞,形容動詞語幹/ =~ target_node then
        nouns.push(node.surface.force_encoding("UTF-8"))
      end
      node = node.next
    end
  return nouns
  end
end

