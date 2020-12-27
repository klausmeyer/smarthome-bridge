RSpec.describe Entry do
  let(:instance) { described_class.new(actor: actor) }

  let(:actor) do
    instance_double('Fritzbox::Smarthome::Actor',
      type:         :device,
      name:         'Heizung Küche',
      hkr_temp_set: 21.0,
      hkr_temp_is:  20.0,
    )
  end

  let(:current_temperature_double) { double(after_update: nil) }
  let(:target_temperature_double)  { double(after_update: nil) }

  describe '#register' do
    before do
      allow(actor).to receive(:update_hkr_temp_set)

      allow(RubyHome::ServiceFactory).to receive(:create).and_return(double(
        current_temperature: current_temperature_double,
        target_temperature:  target_temperature_double,
      ))

      allow(target_temperature_double).to receive(:after_update).and_yield(23.0)
    end

    it 'creates the ruby home service' do
      instance.register

      expect(RubyHome::ServiceFactory).to have_received(:create).with(:thermostat,
        name:                          'Heizung Kuche',
        temperature_display_units:     0,
        target_temperature:            actor.hkr_temp_set,
        current_temperature:           actor.hkr_temp_is,
        target_heating_cooling_state:  Entry::STATE_HEAT,
        current_heating_cooling_state: Entry::STATE_HEAT,
      )
    end

    it 'updates the actor on received events' do
      instance.register

      expect(actor).to have_received(:update_hkr_temp_set).with(23.0)
    end
  end
end
