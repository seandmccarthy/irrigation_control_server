require 'sinatra/base'
require 'mqtt'
require 'json'
require 'irrigation'

class IrrigationServer < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/public'
  set :server, :thin
  set :connections, []

  def self.init_controller
    Irrigation::Controller.new(
      stations: [
        Irrigation::Station.new(id: 1, description: 'Veggie Garden'),
        Irrigation::Station.new(id: 2, description: 'Backyard Garden'),
        Irrigation::Station.new(id: 3, description: 'Front Garden'),
        Irrigation::Station.new(id: 4, description: 'Japanese Garden')
      ],
      message_client: Irrigation::MqttClient.new(host: '10.0.1.202')
    )
  end

  configure do
    set :controller, init_controller
    settings.controller.start
  end

  get '/' do
    send_file 'public/index.html'
  end

  get '/status' do
    content_type :json
    settings.controller.stations.to_json
  end

  post '/stations/:id' do
    settings.controller.send_command(params[:id], params[:command])
    :ok
  end

  run! if app_file == $0
end
