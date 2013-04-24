require 'data/graph'

module Algorithm::Graph

  def self.strongly_connected(graph)
    StronglyConnected.new(graph).find
  end

  class StronglyConnected

    attr_reader :graph, :groups

    def initialize(graph)
      unless graph.kind_of? DataStructure::Graph::Digraph
        raise ArgumentError 'Works only with Digraph'
      end

      @graph = graph
    end

    def find
      order = Algorithm::Graph::topological_sort(graph)
      graph_ = graph.transpose

      @groups = GroupedDepthFirstSearch.new(graph_,order).search.groups

      self
    end

    def to_s
      @groups.inject("< #{self.class} >\n") do |str, group|
        str << "\t{ #{group.join(',')} } \n"
      end
    end

    class GroupedDepthFirstSearch < DepthFirstSearch
      attr_reader :groups

      private

      def init(hash = {})
        super
        @groups = []
        @at  = 0
        @min = @time + 1
      end

      def visit(node)
        if super
          add_node(node)
          next_group if get(node)[:entry] <= @min
        end
      end

      def add_node(node)
        @groups[@at] ||= []
        @groups[@at].unshift node
      end

      def next_group
        @min = @time + 1
        @at += 1
      end

    end

  end

end