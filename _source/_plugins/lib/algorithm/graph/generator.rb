require 'data/graph'

module Algorithm::Graph

  module GraphGenerator

    def initialize(size)
      @size = size
    end

    def generate
      raise NotImplementedError 'MUST IMPLEMENT THIS METHOD'
    end

    private

    def build_graph(klass = DataStructure::Graph::Graph)
      @graph = klass.new
      @size.times { |i| @graph.add_node(i)  }
      @graph
    end

  end

end

require 'algorithm/graph/generator/complete'
require 'algorithm/graph/generator/binomial'
require 'algorithm/graph/generator/regular'
require 'algorithm/graph/generator/limited_edges'