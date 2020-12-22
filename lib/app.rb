require 'registry'
require 'entry'

class App
  class_attribute :logger

  def initialize
    register_actors
  end

  def run
    Thread.new do
      loop do
        update_actors
        Kernel.sleep 5
      end
    end
  end

  private

  delegate :logger, to: :class

  def register_actors
    Fritzbox::Smarthome::Actor.all.each do |actor|
      logger.info "Register actor #{actor.name}"
      Registry.add(Entry.new(actor: actor))
    end
  end

  def update_actors
    Fritzbox::Smarthome::Actor.all.each do |actor|
      logger.info "Updating actor #{actor.name}"
      entry = Registry.entry_with_ain(actor.ain)

      # Explicit check for different value as blindly assigning the value
      # would trigger an update callback even on having the same values.
      if entry.service.current_temperature.to_d != actor.hkr_temp_is.to_d
        entry.service.current_temperature = actor.hkr_temp_is
      end
    end
  end
end
