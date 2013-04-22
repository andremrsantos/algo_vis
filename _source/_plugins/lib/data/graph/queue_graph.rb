require 'data/graph'

module DataStructure::Graph
  class QueueGraph < Graph

    def initialize(nodes = 0, edges = 0)
      @nodes = []
      @num_nodes = 0
      @num_edges = 0

      rand_edges(nodes, edges)
    end

    def add_edge(from, to)
      edge = Edge.new(from, to)

      adjacent(from) << edge
      adjacent(to) << edge
    end

    def edges
      @nodes.inject([]){|edges, v| edges.concat(v) }
    end

    def adjacent(vertex)
      unless @nodes[vertex]
        @nodes[vertex] = []
        @num_vertices += 1
      end

      @nodes[vertex]
    end

    protected

    def rand_edges(nodes, edges)
      for i in (1..edges)
        add_edge(rand(nodes), rand(nodes))
      end
    end

    class Edge

      attr_reader :weight

      def initialize(vertex, other, weight = 1)
        @vertex = vertex
        @other  = other
        @weight = weight
      end

      def either
        @vertex
      end

      def both
        [@vertex, @other]
      end

      def other(vertex)
        throw ArgumentError 'Illegal edge' unless @edges.include? either

        (either == vertex)? @other : either
      end

      def ==(other_)
        return false unless other_.kind_of? Edge

        other_ = other_.both
        other_.include?(@vertex) && other_.include?(@other)
      end

    end

  end

end
