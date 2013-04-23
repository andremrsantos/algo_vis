module DataStructure
  module Heap

    COMPARATOR = {
        min: -> (x, y) { x < y },
        max: -> (x, y) { x > y }
    }

    class HeapBase
      attr_reader :size

      def initialize
        throw NotImplementedError, 'Heap class interface basis'
      end

      def empty?
        size <= 0
      end

      # This class child must implement the following operations:
      #   - insert(key)
      #   - head:
      #     checks the key in the top of the heap
      #   - remove:
      #     checks and remove the key in the top
      #   - change_key(index, key):
      #     alter the key for a node identified by index
      #   - merge(heap):
      #     concatenates two heaps
      #   - contains?(index):
      #     verifies if any key is set to the index
      #   - get(index)
      #     returns the key with the index

      protected

      def compare(x, y)
        @comparator.call(x, y)
      end

    end
  end
end


require 'data/heap/binary_heap'
require 'data/heap/fibonacci_heap'