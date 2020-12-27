class Registry
  include Singleton

  class << self
    delegate :all, :add, :clear!, :entry_with_ain, to: :instance
  end

  def initialize
    clear!
  end

  def all
    entries
  end

  def add(entry)
    entries << entry
  end

  def clear!
    self.entries = []
  end

  def entry_with_ain(ain)
    entries.find { |e| e.actor.ain == ain }
  end

  private

  attr_accessor :entries
end
