require 'rails_helper'

RSpec.describe 'forward spec gem', type: :request do
  let(:body) do
    { data: {
        id: 4
    }
    }.to_json
  end

  before do
    stub_request(:post, 'http://another-dummy.org/dummy')
        .to_return(status: 200)
    stub_request(:get, /http:\/\/another-dummy.org\/dummy*/)
        .to_return(status: 200)
  end

  it 'forward without modification' do
    post '/dummy', params: body
    expect(response.status).to eq(200)
  end

  it 'forward with modification' do
    get '/dummy', params: body
    expect(response.status).to eq(201)
  end
end
