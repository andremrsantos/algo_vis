module DataStructure

  module PriorityQueue

    class VectorQueue

      def initialize(&comparator)
        @keys = {}
        @comparator = comparator || ->(one, other) { one < other}
      end

      def empty?
        @keys.empty?
      end

      def has_key?(key)
        @keys.has_key?(key)
      end

      alias_method :contains?, :has_key?

      def push(key, value = key)
        raise IndexTakenError key if has_key?(key)

        @keys[key] = value
      end

      alias_method :<<, :push
      alias_method :add,:push

      def pop
        min = nil
        @keys.each_key { |key| min = key if min.nil? || compare(key, min) }
        @keys.delete(min)
        min
      end

      alias_method :shift, :pop

      def peek
        min = nil
        @keys.each { |key| min = key if min.nil? || compare(key, min) }
        min
      end

      alias_method :top, :peek

      def change_key(key, value)
        @keys[key] = value
      end

      private

      def compare(one, other)
        @comparator.call(@keys[one], @keys[other])
      end

    end

  end
end
