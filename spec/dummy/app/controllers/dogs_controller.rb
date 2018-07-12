class DogsController < ApplicationController
  def index
    forward after: :update_body
  end

  def create
    forward after: :update_body
  end

  def update_body(response)
    parsed_response = response.parse(:json)
    parsed_response['data']['name'] = 'rex'
    response.body = parsed_response.to_json
  end
end