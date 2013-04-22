require 'forwardable'

class SummaryLogger
  extend Forwardable

  def self.instance
    @@logger ||= SummaryLogger.new
  end

  def self.add(klass = :default, data = {})
    instance.add(klass, data)
  end

  def self.get(klass = :default)
    instance.get(klass)
  end

  def self.has?(klass = :default)
    instance.has?(klass)
  end

  def initialize
    @logs = {}
  end

  def add(klass = :default, data = {})
    @logs[klass] = LogEntry.new(klass, data)
  end

  def get(klass = :default)
    @logs[klass]
  end

  def has?(klass = :default)
    !@logs[klass].nil?
  end

  private

  class LogEntry
    attr_reader :klass, :update

    def initialize(klass = :default, data = {})
      @klass = klass
      @data = data
      @update = Time.now
    end

    def [] (key)
      @data[key]
    end

    def []=(key, value)
      @update = Time.now
      @data[key] = value
    end

    def to_s
      "[%s] : %s --> %s [%s]" % [klass, update.to_s, data.join(',')]
    end
  end

end