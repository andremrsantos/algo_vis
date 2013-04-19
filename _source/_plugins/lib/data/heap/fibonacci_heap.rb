module DataStructure
  require 'data/heap'
  module Heap

    class FibonacciHeap < HeapBase

      def initialize(type=:min)
        # Define the kind of Heap to be implemented: Min or Max
        @comparator = Heap::COMPARATOR[type] || Heap::COMPARATOR[:min]

        @roots = []
        @top = nil
        @keys = []
        @size = 0
      end

      def insert(index, key)
        throw DataStructure::IndexTakenError index if contains?(index)

        node = new_node(index, key)
        @roots << node
        @keys[index] = node
        @size += 1
        update_top(index)
      end

      def head
        get(@top)
      end

      def remove
        top = @roots.delete_at(@top)

        @top = @roots.first.index

        consolidate
        @size -= 1

        top.key
      end

      def change_key

      end

      def contains?(index)
        !@keys[index].nil?
      end

      def get(index)
        @keys[index].key
      end

      def to_s
        @roots.inject('') {|sum, root| sum << node_to_s(root)}
      end

      protected

      Node = Struct.new(:key, :index, :sons, :father, :rank, :mark)

      def new_node(index, key)
        Node.new(key, index, [], nil, 0, false)
      end

      def add_to_roots(sons)
        sons.each{|son| son.father = nil}
        @roots.concat(sons)
      end

      def update_top(index)
        @top = index if @top.nil? || compare(get(index), head)
      end

      def consolidate
        ranks = []
        i = 0

        while i < @roots.size
          current = get_root_at(i)
          rnk = current.rank

          update_top(current.index)

          if ranks[rnk].nil?
            ranks[rnk] = i
            i += 1
          else
            other = get_root_at(ranks[rnk])
            a, b = compare(current.key, other.key)?[i,ranks[rnk]]:[ranks[rnk],i]

            get_root_at(a).sons << get_root_at(b)
            get_root_at(a).rank += 1
            get_root_at(b).father = a
            @roots.delete_at(b)
          end
        end
      end

      def get_root_at(index)
        @roots[index]
      end

      def node_to_s(node,lvl=0)

        str = '| ' * lvl
        str << "\\_#{node.key}\n"
        node.sons.inject(str) { |sum,son| sum << node_to_s(son) }
      end

    end
  end

end