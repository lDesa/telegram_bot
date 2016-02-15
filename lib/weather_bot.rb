require 'telegram/bot'
# require 'weather-api'

require 'net/http'
require 'json'
require 'map'

class Weather_bot 
   
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
			        	weather_today = weather_for_city(city_and_country[:city],city_and_country[:country])
			        end 

				  		bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name}"+"\n"+"#{weather_today}")	

				    end
					end
			  end
	   	
	   end


			private

			def get_response url
			
				  response_uri = Net::HTTP.get_response(URI.parse url).body.to_s
			
        if  Map.new(JSON.parse(response_uri))[:query][:results].nil?
          response = nil
        else
					response = Map.new(JSON.parse(response_uri))[:query][:results][:channel]
				end
			end



			def weather_for_city(city = 'moscow',country = '',unit = 'c')

				url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20
				(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22#{city}%2C#{country}%22)%20and%20u%3D'#{unit}'&format=json"
				response = get_response url

				return "Некорректный ввод,проверте команду" if response.nil?
        
        
				str =  response[:item][:title]+ "\n"
				str += response[:item][:condition][:text] + "\n"
				str += response[:item][:condition][:temp]

			end

			def parse_message message
				
				first_word = message.split(" ")[0]

			  city_and_country = message[first_word.size..-1].split(",")

        hash_of_city_and_country = {city: city_and_country[0]}          unless city_and_country[0].nil? 
        hash_of_city_and_country[:country] = city_and_country[1]        unless city_and_country[1].nil?

			  #return hash of city and country
			  hash_of_city_and_country

			end
  end  

end


