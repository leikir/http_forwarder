class DogsController < ApplicationController

  include HttpForwarder::Forwarder

  def initialize
    super
    set_up_procs
  end

  def index
    forward_and_render
  end

  # modify the dog name to rex before forwarding the request
  def create
    response_from_other_api = forward do |body, path, headers|
      @update_dog_name.call(body, path, headers)
    end
    render_response(response_from_other_api)
  end

  def update
    response = forward
    parsed_response = JSON.parse(response.body)
    parsed_response['data']['name'] = 'droopy'
    render json: parsed_response, status: response.status
  end

  private

  def set_up_procs
    @update_dog_name = Proc.new do |body, path, headers|
      body = JSON.parse(body)
      body['data']['name'] = 'rocky'
      @body = body.to_json
      @path = '/doggos'
      @headers = headers
      @headers['Content-Type'] = 'blabla/json'
    end
  end
end