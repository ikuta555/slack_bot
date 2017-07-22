# saying_slack_bot.rb
require 'http'
require 'json'
require 'faye/websocket'
require 'eventmachine'
require './SlackTextClass.rb'

response = HTTP.post("https://slack.com/api/rtm.start", params: { 
    token: ENV['SLACK_API_TOKEN']
  })
rc = JSON.parse(response.body)
url = rc['url']

EM.run do
  ws = Faye::WebSocket::Client.new(url)
  ts = 0.0
  user = nil

  ws.on :open do
    p [:open]
  end

  ws.on :message do |event|
    data = JSON.parse(event.data)
    p [:message, data]

    unless user==data['user'] then
      case data['type']
      when 'user_typing' then
        text = "<@#{data['user']}> さんが何か言おうとしています。みなさんお静かに..."
      when 'message' then
        reply = SlackText.new('message')
        text = reply.text
      else
        text = nil
      end

      if text then
        ws.send({
          type: 'message',
          text: text,
          channel: data['channel']
          }.to_json)
      end
    end

    user = data['user']

  end

  ws.on :close do
    p [:close, event.code]
    ws = nil
    EM.stop
  end
end
