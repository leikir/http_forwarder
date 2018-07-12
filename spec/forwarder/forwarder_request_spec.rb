require 'rails_helper'

RSpec.describe 'forward spec gem', type: :request do
  let(:body) do
    { data: {
        name: 'bobby'
    }
    }.to_json
  end

  before do
    stub_request(:post, 'http://doggy.woof/dogs')
        .to_return(status: 200, body: body)
  end

  it 'forward with modification' do
    post '/dogs', params: body
    expect(response.status).to eq(200)
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['data']['name']).to eq('rex')
  end

  # it 'forward with modification' do
  #   get '/dogs', params: body
  #   expect(response.status).to eq(201)
  # end
end
