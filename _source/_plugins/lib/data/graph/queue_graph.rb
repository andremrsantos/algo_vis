require 'data/set'

module DataStructure::Graph

  class QueueGraph < GraphBase

    def initialize(order = 0)
      @order = 0
      @size = 0
      @nodes = {} # Integer identified nodes
      init(order)
    end

    def add_edge(node_v, node_w)
      raise ArgumentError, 'Edge already included' if has_edge?(node_v, node_w)
      edge = Edge.new(node_v, node_w)

      @size += 1

      get_or_add_node(node_v) << edge
      get_or_add_node(node_w) << edge unless node_v == node_w
    end

    def add_node(node)
      get_or_add_node(node)
      node
    end

    def remove_edge(node_v, node_w)
      raise NotFoundEdgeError, node_v, node_w unless has_edge?(node_v, node_w)

      @size -= 1

      edge = Edge.new(node_v, node_w)

      get_or_add_node(node_v).delete(edge)
      get_or_add_node(node_v).delete(edge)
    end

    def has_edge?(node_v, node_w)
      return false unless has_node?(node_v) && has_node?(node_w)

      @nodes[node_v].contains?(Edge.new(node_v, node_w))
    end

    def has_node?(node)
      !@nodes[node].nil?
    end

    def adjacent(node)
      raise NotFoundNodeError node unless has_node?(node)

      @nodes[node].items
    end

    def degree(node)
      raise NotFoundNodeError node unless has_node?(node)

      @nodes[node].size
    end

    def transpose
      self.clone
    end

    def edges
      @nodes.inject(DataStructure::Set::Set.new) do |edges, adj|
        edges.merge!(adj.last)
      end.items
    end

    def nodes
      @nodes.keys
    end

    def each_node(&block)
      nodes.each(&block)
    end

    def each_edge(&block)
      edges.each(&block)
    end

    def to_s
      str = " < #{self.class} > \n"
      str << "V: %03d\nE: %03d\n" % [order, size]
      @nodes.inject(str) { |sum, pair| sum << "#{pair.last.to_s}\n" }
    end

    protected

    def get_or_add_node(index)
      unless @nodes[index]
        @order += 1
        @nodes[index] = DataStructure::Set::Set.new
      end
      @nodes[index]
    end

    def init(order)
      order.times { |i| add_node(i) }
    end

    class Edge
      include Comparable

      attr_reader :weight

      def initialize(node, other, weight = 1)
        @node, @other = if node.hash < other.hash
                          [node, other]
                        else
                          [other, node]
                        end
        @weight = weight
      end

      def nodes
        [@node, @other]
      end

      def either
        @node
      end

      def other(node)
        raise ArgumentError, 'Node not found' unless nodes.include? node

        node == @node ? @other : @node
      end

      def <=>(edge)
        unless edge.kind_of? Edge
          raise ArgumentError, 'Compared obj must be an Edge'
        end

        weight <=> edge.weight
      end

      def ==(edge)
        unless edge_.kind_of? Edge
          raise ArgumentError, 'Compared obj must be an Edge'
        end

        edge.edges == [@node, @other]
      end

      def hash
        @node.hash * 43 + @other.hash * 47
      end

      def to_s
        "(#{@node}, #{@other} : #{weight})"
      end

    end

  end

end
