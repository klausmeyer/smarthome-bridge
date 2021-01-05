RSpec.describe App do
  let(:actor_a) { instance_double('Fritzbox::Smarthome::Heater', type: :device, name: 'Actor A', ain: 'ain:01', hkr_temp_is: 20.0, hkr_temp_set: 21.0) }
  let(:actor_b) { instance_double('Fritzbox::Smarthome::Heater', type: :device, name: 'Actor B', ain: 'ain:02', hkr_temp_is: 20.0, hkr_temp_set: 21.0) }
  let(:actor_c) { instance_double('Fritzbox::Smarthome::Heater', type: :device, name: 'Actor C', ain: 'ain:03', hkr_temp_is: 20.0, hkr_temp_set: 21.0) }

  let(:entry_a) { instance_double('Entry', actor: actor_a, service: service, register: nil) }
  let(:entry_b) { instance_double('Entry', actor: actor_b, service: service, register: nil) }
  let(:entry_c) { instance_double('Entry', actor: actor_c, service: service, register: nil) }

  let(:service) { double('RubyHome::Service', current_temperature: 20.5, 'current_temperature=': nil) }

  before do
    Registry.clear!

    App.logger = Logger.new(IO::NULL)

    allow(Fritzbox::Smarthome::Heater).to receive(:all).and_return([
      actor_a,
      actor_b,
      actor_c,
    ])

    allow(Entry).to receive(:new).with(actor: actor_a).and_return(entry_a)
    allow(Entry).to receive(:new).with(actor: actor_b).and_return(entry_b)
    allow(Entry).to receive(:new).with(actor: actor_c).and_return(entry_c)
  end

  describe '#initialize' do
    it 'registers all actors' do
      described_class.new

      expect(Registry.all).to eq [
        entry_a,
        entry_b,
        entry_c,
      ]
    end
  end

  describe '#run' do
    it 'updates all registered actors' do
      instance = described_class.new

      thread = instance.run(loop: false)
      thread.join

      expect(service).to have_received(:current_temperature=).with(20.0).exactly(3).times
    end
  end
end
