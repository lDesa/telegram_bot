require 'net/http'
require 'json'
require 'map'



city = 'moscow'
country = 'russia'
unit = 'c'
url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20
(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22#{city}%2C#{country}%22)%20and%20u%3D'#{unit}'&format=json"




response = Net::HTTP.get_response(URI.parse url).body.to_s
response = Map.new(JSON.parse(response))[:query][:results][:channel]


puts  response[:item][:title]
puts  response[:item][:condition][:text]
puts  response[:item][:condition][:temp].to_i
