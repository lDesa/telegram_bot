require 'weather-api'

module WeatherBot

  class WeatherCondition

    attr_writer :city, :country,:unit

    def initialize(unit = 'c',hash)
      @city    = hash[:city].strip!
      @country = hash[:country]
      @unit    = unit
    end

    def get_weather_today

      woeid = get_woeid_for_city @city
      unless  woeid.nil?
        response = Weather.lookup(woeid, @unit)
      else
        return "Некорректный ввод,проверте команду"
      end

      str =  response.title+ "\n" + response.condition.text + "\n"
      str += response.condition.temp.to_s

    end

    private

      def get_woeid_for_city city = ''

        url =  "http://where.yahooapis.com/v1/places."
        url += "q(#{city})?appid=4b2eada546c1546f5bdc3b8a5afecbc0f00eb294"
        url += "&format=json"
        response_uri = Net::HTTP.get(URI(url)).to_s
        unless Map.new(JSON.parse(response_uri))[:places][:count] == 0
          map  = Map.new(JSON.parse(response_uri))[:places][:place][0][:woeid]
        end
      end


  end

end
