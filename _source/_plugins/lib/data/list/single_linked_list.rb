require 'data/list'

module DataStructure
  module List

    class SingleLinkedList < ListBase

      def initialize
        clear
      end

      def unshift(key)
        if empty?
          start_list(key)
        else
          node = SingleLinkNode.new(key, @start)
          @start = node
        end
        @size += 1
      end

      def append(key)
        if empty?
          start_list(key)
        else
          @end.next = SingleLinkNode.new(key, nil)
          @end = @end.next
        end
        @size += 1
      end

      def shift
        # Remove do começo
        if size == 1
          clear
        else
          @size -= 1
          tmp = @start
          @start = @start.next
          tmp.key
        end
      end

      def pop
        # Remove do fim

        if size == 1
          clear
        else
          @size -= 1
          father = @start
          while father.next.next != nil
            father = father.next
          end
          @end = father
          tmp = father.next
          father.next = nil
          tmp.key
        end

      end

      def contains?(key)
        current = @start
        until current.nil?
          return true if current.key == key
          current = current.next
        end
        return false
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

      protected

      def start_list(key)
        @start = SingleLinkNode.new(key, nil)
        @end = @start
      end

    end

  end
end