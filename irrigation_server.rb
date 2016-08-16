require 'sinatra/base'
require 'mqtt'
require 'json'

class IrrigationServer < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/irrigation_frontend/dist'

  configure do
    set :station_ids, %w(1 2 3 4)
    set :mqtt_broker, 'localhost' # '10.0.1.6'
  end

  def mqtt_client
    @mqtt_client ||= MQTT::Client.connect(settings.mqtt_broker)
  end

  def station_data(id)
    {
      id: id,
      description: "Station #{id}",
      state: station_status(id)
    }
  end

  get '/api/stations' do
    content_type :json
    {
      stations: settings.station_ids.map do |id|
        station_data(id)
      end
    }.to_json
  end

  post '/stations/:id' do
    params.keys.map {|k| "#{k} = #{params[k]}" }.join("\n")
    "station #{params['id']} #{params['foo']}\n"
  end

  get '/api/stations/:id' do |id|
    content_type :json
    {
      station: station_data(id)
    }.to_json
  end

  get '*' do
    send_file 'irrigation_frontend/dist/index.html'
  end

  run! if app_file == $0
end
