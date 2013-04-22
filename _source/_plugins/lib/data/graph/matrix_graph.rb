require 'matrix'
require 'data/graph'

module DataStructure::Graph

  class MatrixGraph < Graph

    def initialize(vertices = 0)
      @adjacency = Matrix.zero(vertices)
    end

    def add_edge(from, to)
      @adjacency[to][from] = @adjacency[from][to] = 1
    end

  end

end
