class Registry
  include Singleton

  class << self
    delegate :add, :entry_with_ain, to: :instance
  end

  def initialize
    self.entries = []
  end

  def add(entry)
    entries << entry
  end

  def entry_with_ain(ain)
    entries.find { |e| e.actor.ain == ain }
  end

  private

  attr_accessor :entries
end
