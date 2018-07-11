class DummyController < ApplicationController
  def index
    forward after: :update_status
  end

  def create
    forward
  end

  def update_status(response)
    response.instance_variable_set(:@status, 201)
  end

  def remove_id(request)
    @prec = JSON.parse(request.body)['data']['id'].delete
  end

  def put_id(response)
    JSON.parse(response.body)['data']['id'] = @prec
  end
end