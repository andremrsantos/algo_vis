module Algorithm::Graph

  class CompleteGraphGenerator
    include GraphGenerator

    def generate(&block)
      block ||= -> { rand * 10 }
      build_graph

      (0...@size).each do |i|
        ((i+1)...size).each do |j|
          add_edge(i, j, &block)
        end
      end

      @graph
    end

    private

    def add_edge(from, to)
      @graph.add_edge(from, to, yield(from, to))
    end

  end

  class CompleteDigraphGenerator < CompleteGraphGenerator

    private

    def add_edge(from, to)
      @graph.add_edge(from, to, yield(from, to))
      @graph.add_edge(to, from, yield(to, from))
    end

    def build_graph
      super(DataStructure::Graph::Digraph)
    end
  end

  def self.complete_generator(size, kind = :graph, &block)
    if kind == :digraph
      CompleteDigraphGenerator.new(size).generate(&block)
    else
      CompleteGraphGenerator.new(size).generate(&block)
    end
  end

end