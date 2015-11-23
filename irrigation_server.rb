require 'sinatra/base'
require 'mqtt'
require 'json'

class IrrigationServer < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/public'

  configure do
    set :station_ids, %w(1 2 3 4)
    set :mqtt_broker, 'localhost' # '10.0.1.6'
  end

  def mqtt_client
    @mqtt_client ||= MQTT::Client.connect(settings.mqtt_broker)
  end

  def station_status(id)
    topic, message = mqtt_client.get("station/#{id}")
    message
  rescue => e
    puts e.message
    'N/A'
  end

  def station_data(id)
    {
      id: id,
      description: "Station #{id}",
      state: station_status(id)
    }
  end

  get '/' do
    erb :index
  end

  get '/stations' do
    content_type :json
    {
      stations: settings.station_ids.map do |id|
        station_data(id)
      end
    }.to_json
  end

  put '/stations/:id' do
  end

  get '/stations/:id' do |id|
    content_type :json
    {
      station: station_data(id)
    }.to_json
  end

  run! if app_file == $0
end
