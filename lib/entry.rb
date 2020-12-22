class Entry
  STATE_OFF  = 0
  STATE_HEAT = 1
  STATE_COOL = 2
  STATE_AUTO = 3

  attr_accessor :actor, :service

  def initialize(actor:)
    self.actor   = actor

    register_service
  end

  private

  def register_service
    self.service = RubyHome::ServiceFactory.create(:thermostat,
      name:                          name_safe,
      temperature_display_units:     0,
      target_temperature:            actor.hkr_temp_set,
      current_temperature:           actor.hkr_temp_is,
      target_heating_cooling_state:  state,
      current_heating_cooling_state: state
    )

    service.target_temperature.after_update do |value|
      App.logger.info "Changed Target Temperature for #{actor.name} to #{value.to_d}"
      actor.update_hkr_temp_set(value.to_d)
    end

    service.current_temperature.after_update do |value|
      App.logger.info "Changed Current Temperature for #{actor.name} to #{value.to_d}"
    end
  end

  def state
    return STATE_OFF unless actor.type == :device

    if actor.hkr_temp_is < actor.hkr_temp_set
      STATE_HEAT
    elsif actor.hkr_temp_is > actor.hkr_temp_set
      STATE_OFF
    else
      STATE_OFF
    end
  end

  def name_safe
    ActiveSupport::Inflector.transliterate(actor.name)
  end
end
