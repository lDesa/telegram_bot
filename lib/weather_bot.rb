require 'telegram/bot'
token = '189479251:AAENfpcRvHfqnfqb0OVKu1Bv3poNg8Vr_sQ'
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.sendMessage(chat_id: message.chat.id, text: "Привет, #{message.from.first_name}")
    end
  end
end