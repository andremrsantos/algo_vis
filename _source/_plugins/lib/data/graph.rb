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
        raise NotImplementedError 'You must use one of the children'
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

        return true
      end

    end

    def self.load(lines, kind = QueueGraph)
      lines = lines.split("\n") if lines.kind_of? String

      graph = kind.new

      lines.each_with_index do |line, node|
        items = line.chomp.split(/[, ;]/)
        items.each do |other|
          v = node.to_i
          w = other.to_i
          graph.add_edge(v, w) unless graph.has_edge?(v, w)
        end
      end

      graph
    end

    def self.load_with_weight(lines, kind = WeightedQueueDigraph)
      lines = lines.split("\n") if lines.kind_of? String

      graph = kind.new

      lines.each_with_index do |line, node|
        items = line.chomp.split(/[, ;]/)
        items.each do |other|
          v      = node.to_i
          w      = other.gsub(/:.+$/, '').to_i
          weight = other.gsub(/^.+:/, '').to_f
          graph.add_edge(v, w, weight) unless graph.has_edge?(v, w, weight)
        end
      end

    end

  end
end

# require graphs implementations
require 'data/graph/queue_graph'
require 'data/graph/queue_digraph'
require 'data/graph/weighted_queue_digraph'
require 'data/graph/weighted_queue_digraph'