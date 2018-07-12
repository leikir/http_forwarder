require 'spec_helper'

RSpec.describe HttpForwarder::Forwarder, type: :model do
  context 'configuration' do
    let(:target) { 'http://another-dummy.org' }
    before do
      HttpForwarder::Forwarder.configure do |config|
        config.clear
        config.routes = []
        config.routes << { controller: :dummy, action: :index, to: target }
      end
      class DummyClass
        include HttpForwarder::Forwarder
      end
    end

    subject { DummyClass.new.send(:routes) }
    it 'has the correct number of configured routes' do
      expect(subject.size).to eq(1)
    end
    it 'has the correct route' do
      expect(subject.first[:to]).to eq(target)
    end
  end
end
