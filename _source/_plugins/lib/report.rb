module Report

  def self.realtime
    now = Time.now.nsec
    yield
    Time.now.nsec - now
  end

  def self.simple_name(klass)

    case klass
    when Class then klass.name.gsub(/^.*::/, '')
    when String then klass.gsub(/^.*::/, '')
    else simple_name(klass.class)
    end

  end

  class Report

    def initialize
      @values = {}
      @format = {}
    end

    def add(field, value, format = nil)
      format ||= case value
                 when Integer then '%03d'
                 when Numeric then '%02.5f'
                 else '%10s'
                 end
      @values[field] = value
      @format[field] = format
      self
    end

    def get(field)
      @values[field]
    end

    def has_field?
      ! @values[field].nil?
    end

    def to_s
      join
    end

    def join(delim = ',')

      @values.keys.inject('') do |sb, key|
        sb << (@format[key] + delim) % @values[key]
      end
    end

    def merge(other)
      raise ArgumentError 'Merges only to Report' if other.kind_of? Report
      @values.merge(other.instance_variable_get :@values)
      @format.merge(other.instance_variable_get :@format)
    end

  end

end

require 'report/algorithm'
require 'report/graph'