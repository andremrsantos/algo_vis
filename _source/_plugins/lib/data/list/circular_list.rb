require 'data/list'

module DataStructure
  module List

    class CircularList < ListBase
      alias_method :unshift, :append
      alias_methos :pop, :shift

      def initialize
        clear
      end

      def last
        @start.nil? ? nil : @start.last.key
      end

      def shift_right
        @start = @start.next
      end

      def shift_left
        @start = @start.last
      end

      def append(key)
        if empty?
          init(key)
        else
          node = DoubleLinkNode.new(key, @start, @start.last)
          @start.last.next = node
          @start.last = node
        end
        @size += 1
      end

      def shift
        if size == 0
          clear
        else
          size -= 1
          tmp = @start
          @start.last.next = tmp.next
          @start.next.last = tmp.last
          tmp.key
        end
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

        until idx > index
          current = current.next
          idx += 1
        end
      end

      protected

      def init(key)
        node = DoubleLinkNode.new(key, nil, nil)
        node.last = node
        node.next = node

        @start = node
      end

    end

  end
end