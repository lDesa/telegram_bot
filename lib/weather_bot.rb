require 'telegram/bot'
require 'net/http'
require 'json'
require 'map'

require_relative "weather"


module WeatherBot

  class << self

    def run_bot

      token = '189479251:AAENfpcRvHfqnfqb0OVKu1Bv3poNg8Vr_sQ'
      Telegram::Bot::Client.run(token) do |bot|

        bot.listen do |message|

          case message.text.split(" ")[0]
          when '/start'
            bot.api.sendMessage(chat_id: message.chat.id,
                                   text: "Привет, #{message.from.first_name}")
          when '/weather'
            city_and_country = parse_message(message.text)

            if  city_and_country.nil?
              weather_today = "Некорректный ввод,проверте команду"
            else
              response_today = Weather.new(city_and_country).get_response_today
            end
            bot.api.sendMessage(chat_id: message.chat.id,
                                   text: "#{message.from.first_name}"+"\n"+"#{response_today}")
          when '/help'
            bot.api.sendMessage(chat_id: message.chat.id,
                                   text: "Чтобы узнать погоду на сегодня\n"+
                                   "Введите команду в формате:\n"+
                                   "/weather city,country")
          end
        end
      end
    end

    private


    def parse_message message

      first_word = message.split(" ")[0]

      city_and_country = message[first_word.size..-1].split(",")

      geo_hash = { city: city_and_country[0], country: city_and_country[1] }

    end
  end
end
