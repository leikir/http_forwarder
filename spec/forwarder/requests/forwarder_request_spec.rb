require 'rails_helper'

RSpec.describe 'forward spec gem', type: :request do
  let(:body) do
    {
      data: {
        name: 'bobby'
      }
    }.to_json
  end

  let(:modified_body) do 
    {
      data: {
        name: 'rocky'
      }
    }.to_json
  end

  let(:returned_body) do
    {
      data: {
            id: 4,
            name: 'rex'
      }
    }.to_json
  end

  let(:returned_cat_body) do 
    {
      data: {
        id: 5,
        name: 'felix'
      }
    }.to_json
  end

  before do
    # we have to reload our initializer because it has been overwritten
    # when we tested our forwarder model
    require 'dummy/config/initializers/forwarder'
    
    stub_request(:post, 'http://doggy.woof/doggos')
      .with(body: modified_body, headers: { 'Content-Type' => 'blabla/json' })
      .to_return(status: 200)
    stub_request(:put, 'http://doggos.woof/dogs/4')
      .to_return(status: 201, body: returned_body)
    stub_request(:get, 'http://doggos.woof/dogs')
      .to_return(status: 200, body: body)
    stub_request(:get, 'http://kittykitty.miaw/cats')
      .to_return(status: 200)
    stub_request(:post, 'http://kittykitty.miaw/cats')
      .to_return(status: 200, body: returned_cat_body)
  end

  it 'forward with modification on request' do
    post '/dogs', params: body
    expect(response.status).to eq(200)
  end

  it 'forward with modification on response' do
    put '/dogs/4', params: body
    expect(response.status).to eq(201)
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['data']['name']).to eq('droopy')
    expect(parsed_response['data']['id']).to eq(4)
  end

  it 'forward without modification' do
    get '/dogs'
    expect(response.status).to eq(200)
    expect(JSON.parse(response.body)['data']['name']).to eq('bobby')
  end

  context 'forward to the same target for all actions if not specified' do 
    it 'forwards to the target in one action' do 
      get '/cats'
      expect(response.status).to eq(200)
    end

    it 'forwards to the target in another action' do 
      post '/cats'
      expect(response.status).to eq(200)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data']['name']).to eq('felix')
    end
  end
end
