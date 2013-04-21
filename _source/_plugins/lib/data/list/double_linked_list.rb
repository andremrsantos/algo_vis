require 'data/list'

module DataStructure
  module List

    class DoubleLinkedList < ListBase

      def initialize
        clear
      end

      def unshift(key)
        if empty?
          init(key)
        else
          node = DoubleLinkNode(key, @start, nil)
          @start.last = node
          @start = node
        end
        @size += 1
      end

      def append
        if empty?
          init(key)
        else
          node = DoubleLinkNode(key, nil, @end)
          @end.next = node
          @end = node
        end
        @size += 1
      end

      def shift
        if size == 0
          clear
        else
          @size -=1

          tmp = @start
          tmp.next.last = nil
          @start = tmp.next
          tmp.key
        end
      end

      def pop
        if size == 0
          clear
        else
          @size -=1

          tmp = @end
          tmp.last.next = nil
          @end = tmp.last
          tmp.key
        end
      end

      def get(index)
        throw DataStructure::NoSuchElementError index if index >= size

        (index > size/2)? back_look(index) : foward_look(index)
      end

      def concat(list)
        @end.next = list.start_node
        list.start.last = @end
      end

      protected

      def init(key)
        @start = DoubleLinkNode.new(key, nil, nil)
        @end = @start
      end

      def back_look(index)
        idx = 0
        current = @start
        while idx < index
          current = current.next
          idx += 1
        end

        current.key
      end

      def foward_look(index)
        idx = size - 1
        current = @end
        while idx > index
          current = current.last
          idx -= 1
        end

        current.key
      end

    end

  end
end