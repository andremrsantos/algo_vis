require 'data/graph'

module Algorithm::Graph

  module MinPath
    INFINITY = 1.0/0

    attr_reader :graph

    def initialize(graph)
      raise ArgumentError unless graph.kind_of? DataStructure::Graph::Digraph
      @graph = graph
    end

    def find(start)
      raise NotImplementedError 'MUST IMPLEMENT THIS METHOD'
    end

    def get(node)
      @nodes[node]
    end

    protected

    def init(attr = {})
      @nodes = {}
      @graph.each_node {|n| @nodes[n] = attr.clone}
    end

    def relax(edge)
      if get(edge.to)[:distance] > get(edge.from)[:distance] + edge.weight
        update(edge)
      end
    end

    def update(edge)
      get(edge.to)[:distance] = get(edge.from)[:distance] + edge.weight
      get(edge.to)[:parent] = edge.from
    end

  end

end

require 'algorithm/graph/min_path/dijkstra'

