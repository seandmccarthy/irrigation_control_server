require 'sinatra/base'
require 'mqtt'
require 'json'

class IrrigationServer < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/public'

  configure do
    set :station_ids, %w(1 2 3 4)
    set :mqtt_broker, 'localhost' # '10.0.1.6'
  end

  def station_data(id)
    {
      id: id,
      description: "Station #{id}",
      state: station_status(id)
    }
  end

  get '/' do
    send_file 'public/index.html'
  end

  post '/stations/:id' do
    "got: #{params["command"]}"
  end

  run! if app_file == $0
end
