module DataStructure
  module Set

    class Set
      include Enumerable

      def initialize
        @items = {}
      end

      def empty?
        @items.size == 0
      end

      def size
        @items.size
      end

      def add(key)
        @items[key] = true
        self
      end

      alias_method :<<, :add
      alias_method :push, :add
      alias_method :insert, :add

      def delete(key)
        @items.delete(key) if has?(key)
        self
      end

      alias_method :remove, :delete

      def contains?(key)
        !@items[key].nil?
      end

      def each(&block)
        items.each(&block)
      end

      def items
        @items.keys
      end

      def clear
        @items = {}
      end

      def merge(other)
        self.clone.merge!(other)
      end

      def merge!(other)
        other.each { |key| self.add(key) }
        self
      end

      alias_method :+, :merge

      def subtract(other)
        self.clone.subtract!(other)
      end

      def subtract!(other)
        other.each { |key| delete(key) }
        self
      end

      alias_method :-, :subtract

      def map(&block)
        self.copy.map!(&block)
      end

      def map!
        items.map do |item|
          key = yield(item)
          delete(item)
          add(key)
        end
      end

      def to_s
        "{ #{items.join(',')} }"
      end

      def inspect
        "< #{self.class} : #{self.to_s} >"
      end

    end

    class MultiSet < Set

      def add(key, count = 1)
        @items[key] ||= 0
        @items[key] += count
      end

      def delete(key, count = 1)
        if @items[key] <= count
          delete_all(key)
        else
          @items[key] -= count
        end
      end

      def delete_all(key)
        @items.delete(key)
      end

      def get(key)
        @items[key] || 0
      end

      alias_method :[], :get

      def each_with_count(&block)
        @items.each_pair(&block)
      end

      def each
        items.each do |item|
          get(item).times { yield (items) }
        end
      end

      def merge!(other)
        case other
        when Array
          super.merge!(other)
        when MultiSet
          other.each_with_count { |item, count| add(item, count) }
        when Enumerable
          super.merge!(other)
        else
          raise ArgumentError 'Incompatible type'
        end
      end

      def subtract!(other)
        case other
        when Array
          super.subtract!(other)
        when MultiSet
          other.each_with_count { |item, count| delete(item, count) }
        when Enumerable
          super.subtract!(other)
        else
          raise ArgumentError 'Incompatible type'
        end
      end

      def to_s
        "{ #{@items.collect { |item| "(#{item} : #{get(key)})" }.join(',')} }"
      end

    end
  end

end