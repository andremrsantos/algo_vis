require 'algorithm/shuffle'

module Algorithm::Graph

  class LimitedEdgeGraphGenerator
    include GraphGenerator

    def initialize(size, limit)
      super(size)
      raise ArgumentError 'Unreachable condition' if limit > size_limit
      @limit = limit
    end

    def generate(&block)
      block ||= lambda {|_,_| rand * 10 }

      build_graph

      edges = combinations(@graph.nodes)

      until reached?
        rnd = rand(edges.size)
        from, to = edges.delete_at(rnd)
        add_edge(from, to, &block)
      end

      @graph
    end

    private

    def reached?
      @graph.size >= @limit
    end

    def size_limit
      @size * (@size-1)/2
    end

    def add_edge(from, to)
      @graph.add_edge(from, to, yield(from, to))
    end

    def combinations(nodes)
      arr = []
      (0...nodes.size).each do |i|
        ((i+1)...nodes.size).each do |j|
          arr << [nodes[i], nodes[j]]
        end
      end
      arr
    end
  end

  class LimitedEdgeDigraphGenerator < LimitedEdgeGraphGenerator

    private

    def size_limit
      @size * (@size-1)
    end

    def combinations(nodes)
      arr = []
      (0...nodes.size).each do |i|
        ((i+1)...nodes.size).each do |j|
          arr << [nodes[i], nodes[j]]
          arr << [nodes[j], nodes[i]]
        end
      end
      arr
    end

    private

    def build_graph
      super(DataStructure::Graph::Digraph)
    end

  end

  def self.limited_edges_generator(size, edges, type = :graph, &block)
    if type == :digraph
      LimitedEdgeDigraphGenerator.new(size, edges).generate(&block)
    else
      LimitedEdgeGraphGenerator.new(size, edges).generate(&block)
    end
  end

end