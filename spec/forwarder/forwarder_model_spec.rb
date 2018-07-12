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

    context 'one route' do 
      subject { DummyClass.new.send(:routes) }
      it 'has the correct number of configured routes' do
        expect(subject.size).to eq(1)
      end
      it 'has the correct route' do
        expect(subject.first[:to]).to eq(target)
      end
    end

    context 'multiple routes' do 
      before do 
        HttpForwarder::Forwarder.configure do |config|
          config.routes << { controller: :dummy, action: :create, to: target }
        end
      end

      subject { DummyClass.new.send(:routes) }
      it 'has the correct number of configured routes' do 
        expect(subject.size).to eq(2)
      end

      it 'has the correct destinations' do 
        expect(subject[0][:to]).to eq(subject[1][:to])
        expect(subject[1][:to]).to eq(target)
      end
    end

    # context 'find destination' do 
    #   context 'success' do 
    #     before do 
    #       HttpForwarder::Forwarder.configure do |config|
    #         config.routes << { controller: :dummy, action: :create, to: target }
    #       end
    #     end
        
    #     subject { DummyClass.new.send(:routes) }


    #     # it 'raise a no route error' do 
    #     #   expect{subject}.to raise(RuntimeError)
    #     # end
    #   end
    # end


  end
end