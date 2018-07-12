require 'rails_helper'

RSpec.describe 'forward spec gem', type: :request do
  let(:body) do
    { data: {
        name: 'bobby'
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

  before do
    stub_request(:post, 'http://doggy.woof/dogs')
        .to_return(status: 200, body: returned_body)
    stub_request(:put, 'http://doggos.woof/dogs/4')
        .to_return(status: 201, body: returned_body)
    stub_request(:get, 'http://doggos.woof/dogs')
        .to_return(status: 200, body: body)
  end

  it 'forward with modification on request' do
    post '/dogs', params: body
    expect(response.status).to eq(200)
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['data']['name']).to eq('rex')
    expect(parsed_response['data']['id']).to eq(4)
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
end
