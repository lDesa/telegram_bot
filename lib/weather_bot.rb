require 'telegram/bot'
require 'net/http'
require 'json'
require 'map'

require_relative "response_today"


module Weather_bot

  class << self

    def run_bot

      token = '189479251:AAENfpcRvHfqnfqb0OVKu1Bv3poNg8Vr_sQ'

      Telegram::Bot::Client.run(token) do |bot|

        bot.listen do |message|


          if message.text == '/start'
            bot.api.sendMessage(chat_id: message.chat.id, text: "Привет, #{message.from.first_name}")
          end

          if message.text.split(" ")[0] == '/weather'

            city_and_country = parse_message(message.text)

              if  city_and_country.nil?
                weather_today = "Некорректный ввод,проверте команду"
              else
                response_today = ResponseToday.new city_and_country
                weather_today = response_today.response
              end

            bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name}"+"\n"+"#{weather_today}")
          end

        end

      end

    end

    private

    def parse_message message

      first_word = message.split(" ")[0]

      city_and_country = message[first_word.size..-1].split(",")

      hash_of_city_and_country = {city: city_and_country[0]}   unless city_and_country[0].nil?
      hash_of_city_and_country[:country] = city_and_country[1] unless city_and_country[1].nil?

      #return hash of city and country
      hash_of_city_and_country

    end
  end
end

