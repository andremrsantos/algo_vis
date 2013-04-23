module DataStructure::Graph

  class QueueDigraph < QueueGraph
    include Digraph

    def add_edge(node_v, node_w)
      raise ArgumentError 'Node already included' if has_edge?(node_v, node_w)

      edge = DirectedEdge.new(node_v, node_w)

      @size += 1
      get_or_add_node(node_v) << edge
    end

    def remove_edge(node_v, node_w)
      raise NotFoundEdgeError node_v, node_w unless has_edge?(node_v, node_w)

      edge = DirectedEdge.new(node_v, node_w)

      get_or_add_node(node_v).delete(edge)
    end

    def indegree(node)
      raise NotFoundNodeError node unless has_node?(node)

      degree = 0
      each_edge { |edge| degree += 1 if edge.to == node }

      degree
    end

    alias_method :outdegree, :degree

    def transpose
      graph = QueueDigraph.new(order)

      each_edge { |edge| graph.add_edge(edge.to, edge.from) }

      graph
    end

    class DirectedEdge < Edge

      def initialize(node, other, weight = 1)
        @node = node
        @other = other
        @weight= weight
      end

      def from
        @node
      end

      def to
        @other
      end

    end

  end


end