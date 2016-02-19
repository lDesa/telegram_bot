require_relative "lib/weather_bot"
require 'yaml'

cnf = YAML::load(File.open('config.yml'),'r')

unless cnf['token'].empty?
  WeatherBot.run(cnf['token'])
end
