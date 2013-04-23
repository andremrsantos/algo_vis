module Algorithm::Graph

  def self.topological_sort(graph)
    TopologicalSort.new(graph).sort.nodes
  end

  class TopologicalSort
    attr_reader :graph, :nodes

    def initialize(graph)
      unless graph.kind_of? DataStructure::Graph::Digraph
        raise ArgumentError 'Works only with Digraph'
      end

      @graph = graph
    end

    def sort
      @nodes = TopologicalDepthFirstSearch.new(graph).search.nodes
    end

    def to_s
      "{ #{nodes.join(',')} }"
    end

    class TopologicalDepthFirstSearch < DepthFirstSearch
      attr_reader :nodes

      def visit(node)
        raise CyclicGraphError if get(node)[:color] != :white

        super
      end

      protected

      def init(hash = {})
        super
        @nodes = []
      end

      def exit_node(node)
        super
        @nodes.unshift(node)
      end

    end

  end

end