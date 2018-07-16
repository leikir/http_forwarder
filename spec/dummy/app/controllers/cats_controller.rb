class CatsController < ApplicationController

  include HttpForwarder::Forwarder

  def index
    forward_and_render
  end

  def create
    forward_and_render
  end
end