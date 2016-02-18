module WeatherBot

  class Weather

    attr_writer :city, :country,:unit

    def initialize(unit = 'c',hash)
      @city    = hash[:city]
      @country = hash[:country]
      @unit    = unit
    end

    def get_response_today()

      url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather."
      url += "forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%"
      url += "20text%3D%22#{@city}%2C#{@country}%22)%20and%20u%3D'#{@unit}'&format=json"
      response = get_response url

      return "Некорректный ввод,проверте команду" if response.nil?


      str =  response[:item][:title]+ "\n"
      str += response[:item][:condition][:text] + "\n"
      str += response[:item][:condition][:temp]

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




  end

end
