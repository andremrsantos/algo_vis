module Report

  def self.realtime
    now = Time.now
    yield
    Time.now - now
  end

  def self.simple_name(klass)

    case klass
    when Class then klass.name.gsub(/^.*::/, '')
    when String then klass.gsub(/^.*::/, '')
    else simple_name(klass.class)
    end

  end

  class ReportEntry

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

    def fields
      @values.keys
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

  class Report
    include Enumerable

    def initialize
      @fields = {}
      @entries= []
    end

    def append(entry)
      entry.fields.each do |field|
        @fields[field] = field
      end

      case entry
      when ReportEntry then @entries << entry
      when Report then @entries.concat(entry.entries)
      end

      self
    end

    alias_method :<<, :append

    def add(field, value, format = nil)
      @fields[field] = field
      @entries.each { |entry| entry.add(field, value, format) }
      self
    end

    def fields
      @fields.keys
    end

    def entries
      @entries
    end

    def each(&block)
      @entries.each(&block)
    end

    def to_s
      str = fields.inject('') {|sb, field| sb << "%8s\t" % field}
      str << "\n"
      str << join
    end

    def join(delim = ',')
      @entries.inject('') do |str, entry|
        str << entry.join(delim)
        str << "\n"
      end
    end

  end

end

require 'report/algorithm'
require 'report/graph'