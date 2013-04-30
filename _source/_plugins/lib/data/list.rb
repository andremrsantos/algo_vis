module DataStructure
  module List

    class ListBase
      include Enumerable

      attr_reader :size

      def initialize(type)
        throw NotImplementedError 'Abstract class, please use an child'
      end

      def append(key)
        throw NotImplementedError 'This method must be implemented'
      end

      def shift
        throw NotImplementedError 'This method must be implemented'
      end

      def clear
        @start = nil
        @end = nil
        @size = 0
      end

      def empty?
        @size <= 0
      end

      def first
        start_node.nil? ? nil : start_node.key
      end

      def last
        end_node.nil? ? nil : start_node.key
      end

      def each
        unless empty?
          current = @start
          until current.nil?
            yield current.key
            current = current.next
          end
        end
        self
      end

      def contains?(key)
        current = @start
        until current.nil?
          return true if current.key == key
          current = current.next
        end
        false
      end

      def get(index)
        throw DataStructure::NoSuchElementError index if index >= size

        idx = 0
        current = @start

        while idx < index
          current = current.next
          idx += 1
        end

        current.key
      end

      alias_method :add, :append
      alias_method :remove, :shift

      alias_method :peek, :first

      protected

      SingleLinkNode = Struct.new(:key, :next)
      DoubleLinkNode = Struct.new(:key, :next, :last)

      def start_node
        @start
      end

      def end_node
        @end
      end

      # Must implement the following operations:
      # - add
      # - remove
      # - contains? (key)
      # - get
      # - size
    end

  end
end

require 'data/list/circular_list'
require 'data/list/double_linked_list'
require 'data/list/single_linked_list'