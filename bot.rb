# bot.rb
require 'http'
require 'json'
require 'faye/websocket'
require 'eventmachine'
require './Message.rb'

SLACK_API_URL = 'https://slack.com/api/rtm.start'

response = HTTP.post(SLACK_API_URL, params: { 
    token: ENV['SLACK_API_TOKEN']
  })
rc = JSON.parse(response.body)
url = rc['url']

EM.run do
  # Web Socketインスタンスの立ち上げ
  ws = Faye::WebSocket::Client.new(url)

  #  接続が確立した時の処理
  ws.on :open do
    p [:open]
  end

  # RTM APIから情報を受け取った時の処理
  ws.on :message do |event|
    data = JSON.parse(event.data)
    p [:message, data]
    if data['type'] == 'message' && data['user'] then
      replay_text = Message.replay_message(data['text'])
      unless replay_text == 0 then
        ws.send({
          type: 'message',
          text: replay_text,
          channel: data['channel']
          }.to_json)
      end
    end
  end

  # 接続が切断した時の処理
  ws.on :close do
    p [:close]
    ws = nil
    EM.stop
  end
end
