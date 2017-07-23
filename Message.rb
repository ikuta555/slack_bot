# message.rb
require './Saying.rb'

class Message
  class << self

    def replay_message(message)
      if match_data = Saying.match_data(message) then
        saying = Saying.new(match_data[:index])
        "「#{match_data[:noun]}」と言えば、こちらの名言をご覧ください。\n\n>#{saying.dialog}\n>\n>-  #{saying.greatman}  -\n>"
      else
        0
      end
    end

  end
end
