require 'rails_helper'

RSpec.describe RouterConfigurator do

  let(:router_configurator) { RouterConfigurator.new }
  let(:target) { 'http://dummy.org' }
  let(:another_target) { 'http://another-dummy.org' }

  context 'we add one route' do

    before do
      router_configurator.forward(:user).on(:index).to(target)
    end

    it 'contains the specified route' do
      r = router_configurator.routes
      expect(r.size).to eq(1)
      expect(r.first[:to]).to eq(target)
    end

  end

  context 'we add several routes' do

    before do
      router_configurator.forward(:user).on(:create).to(target)
      router_configurator.forward(:dogs).on(:index).to(another_target)
    end

    it 'contains the specified routes' do
      r = router_configurator.routes
      expect(r.size).to eq(2)
      expect(r.last[:to]).to eq(another_target)
    end
  end

  context 'we add a route with no action' do
    before do
      router_configurator.forward(:user).to(target)
    end

    it 'redirects to the target' do
      r = router_configurator.routes
      expect(r.first[:to]).to eq(target)
    end
  end
end