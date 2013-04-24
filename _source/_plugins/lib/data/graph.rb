module DataStructure
  module Graph

    class NotFoundEdgeError < ArgumentError

      def initialize(node_v, node_w)
        super "(#{node_v},#{node_w}) was not found in the graph"
      end

    end

    class NotFoundNodeError < ArgumentError

      def initialize(node)
        super "(#{node}) was not found in the graph"
      end

    end

    class GraphBase

      include Enumerable

      attr_reader :order, :size

      def initialize
        QueueGraph.new
      end

      # This class children must implement the following methods:
      #   - add_edge    (node, node)
      #   - remove_edge (node, node)
      #   - has_edge?   (node, node)
      #   - adjacent    (node)
      #   - degree      (node)
      #   - transpose
      #   - edges
      #   - nodes
      #   - each_node
      #   - each_edges
      # And mus define the following variables
      #   - order       Number of node in the graph
      #   - size        Number of edges in the graph

      def add_edge
        raise NotImplementedError 'Add_Edge method must be implemented'
      end

      alias_method :<<, :add_edge
      alias_method :connect, :add_edge

      def remove_edge
        raise NotImplementedError 'Remove_Edge method must be implemented'
      end

      alias_method :disconnect, :remove_edge

      def each_node
        raise NotImplementedError 'Each_Node method must be implemented'
      end

      alias_method :each, :each_node

      def empty?
        order == 0
      end

      def regular?
        degree = degree(first)

        each_node do |node|
          return false if degree(node) != degree
        end

        true
      end

      def euler?
        each_node do |node|
          return false unless degree(node) % 2 == 0
        end
        return true
      end

      def adjacent_matrix(visit_order = graph.nodes)
        matrix = []
        for i in 0...order
          matrix[i] = []

          adjacent(visit_order[i]).each do |edge|
            other = visit_order.index( edge.other(visit_order[i]) )
            matrix[i][other] = edge.weight
          end

          matrix[i][order] = visit_order[i]
        end
        matrix[order] = visit_order
        matrix
      end

    end

    module Digraph

      def euler?
        each_node do |node|
          return false unless indegree(node) == outdegree(node)
        end
        return true
      end

    end

    def self.load(lines, kind = QueueGraph)
      lines = lines.split("\n") if lines.kind_of? String

      order = lines.shift.chomp.to_i
      graph = kind.new(order)

      lines.each do |edge|
        node_v, node_w = edge.chomp.split(/[ ,;\t]/)
        graph.add_edge(node_v.to_i, node_w.to_i)
      end

      graph
    end

    def self.load_weighted(lines, kind = WeightedQueueDigraph)
      lines = lines.split("\n") if lines.kind_of? String

      order = lines.shift.chomp.to_i
      graph = kind.new

      lines.each do |edge|
        node_v, node_w, weight = edge.chomp.split(/[ ,;\t]/)
        graph.add_edge(node_v.to_i, node_w.to_i, weight.to_f)
      end

      graph
    end

  end
end

# require graphs implementations
require 'data/graph/queue_graph'
require 'data/graph/queue_digraph'
require 'data/graph/weighted_queue_digraph'
require 'data/graph/weighted_queue_digraph'