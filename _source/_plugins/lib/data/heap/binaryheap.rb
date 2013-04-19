module DataStructure
  require 'data/heap'

  module Heap

		class BinaryHeap < HeapBase

      def initialize(type = :min)
        # Define the kind of Heap to be implemented: Min or Max
        @comparator = Heap::COMPARATOR[type] || Heap::COMPARATOR[:min]

        # Define working variables
        @queue = []
        @keys = []
        @key_position = []
      end

      def insert(index, key)
        throw Heap::IndexTakenError index if contains?(index)

        @key_position[index] = size
        @queue[size] = index
        @keys[index] = key
        swim
      end

      def head
        key_at(first)
      end

      def remove
        exchange(first,size-1)

        min = @queue.pop
        sink

        @key_position[min] = nil
        @keys.delete_at(min)
      end

      def change_key(index, key)
        throw Heap::NoSuchElementError index unless contains?(index)

        @keys[index] = key
        sink(index)
        swim(index)
      end

      def contains?(index)
        !get(index).nil?
      end

      def get(index)
        @keys[index]
      end

      def size
        return @queue.size
      end

      def to_s
        node_to_s
      end

      protected

      def last
        @queue.size - 1
      end

      def first
        0
      end

      def swim(node=last)
        while has_better_father?(node)
          father = father(node)
          exchange(node, father)
          node = father
        end
      end

      def has_better_father?(node)
        node > 0 && compare(father(node),node)
      end

      def father(node)
        (node+1)/2
      end

      def sink(node=first)
        while has_sons(node)
          son = next_son(node)
          if compare(son, node)
            exchange(son, node)
            node = son
          end
        end
      end

      def has_sons(node)
        (2*node + 1) < size
      end

      def next_son(node)
        son_a,son_b = sons(node)
        (son_b < size && compare(son_b, son_a))? son_b : son_a
      end

      def sons(node)
        son = 2*node + 1
        [son, (son+1)]
      end

      def exchange(from,to)
        # Update Priority Queue
        tmp = @queue[from]
        @queue[from] = @queue[to]
        @queue[to] = tmp
        # Update Key reference
        @key_position[@queue[from]] = from
        @key_position[@queue[to]] = to
      end

      def compare(x,y)
        super(key_at(x),key_at(y))
      end

      def key_at(node)
        get(@queue[node])
      end

      def node_to_s(node=first,lvl=0)
        return '' if node >= size

        son_a, son_b = sons(node)
        str = '| '*lvl
        str << "\\_#{key_at(node)}\n"
        str << node_to_s(son_a, lvl+1)
        str << node_to_s(son_b, lvl+1)
      end

    end

    class FibonacciHeap

      def initialize(type=:min)
        # Define the kind of Heap to be implemented: Min or Max
        @comparator = Heap::COMPARATOR[type] || Heap::COMPARATOR[:min]

        @roots = []
        @top = nil
        @keys = []
        @size = 0
      end

      def insert(index, key)
        throw Heap::IndexTakenError index if contains?(index)

        @roots << index
        @top = index if compare(key, @keys[top])
        @keys[index] = key
      end

      def head
        @keys[@top]
      end

      def remove

      end

      def change_key

      end

      def contains?(index)
        !@keys[index].nil?
      end

      protected

      def new_node(index)
        Struct.new(index: index, sons: [], father: nil)
      end

    end
	end
end