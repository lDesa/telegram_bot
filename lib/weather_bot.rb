require 'telegram/bot'
# require 'weather-api'

require 'net/http'
require 'json'
require 'map'


def get_response url
	begin
	  response = Net::HTTP.get_response(URI.parse url).body.to_s
	rescue => e
	  raise "Failed to get weather [url=#{url}, e=#{e}]."
	end

	response = Map.new(JSON.parse(response))[:query][:results][:channel]

	if response.nil? or response.title.match(/error/i)
	  raise "Failed to get weather [url=#{url}]."
	end

	response
end



def weather_for_city(city = 'moscow',country = '',unit = 'c')

	url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20
	(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22#{city}%2C#{country}%22)%20and%20u%3D'#{unit}'&format=json"
	response = get_response url 


	str =  response[:item][:title]+ "\n"
	str += response[:item][:condition][:text] + "\n"
	str += response[:item][:condition][:temp]

end

def parse_message message
   arg = message.to_s.split(" ")
   str = ''
   1.upto(arg.size-2) {|i| str+= arg[i]+" " }
    print str 
    str
end




token = '189479251:AAENfpcRvHfqnfqb0OVKu1Bv3poNg8Vr_sQ'
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|

	     bot.api.sendMessage(chat_id: message.chat.id, text: "Привет, #{message.from.first_name}") if message.text == '/start'
	  	 
	  	 if message.to_s[0..7] == '/weather' 
     	
	      
	      city = parse_message message.to_s
       
        weather_today = weather_for_city(city) 

	  		bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name}"+"\n"+"#{weather_today}")	

	     end
	end
end
	  		      




