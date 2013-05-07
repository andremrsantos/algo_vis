module Algorithm::Graph

  class BinomialGraphGenerator < CompleteGraphGenerator

    def initialize(size, rate)
      super(size)
      @rate = rate
    end

    private

    def add?
      rand < @rate
    end

    def add_edge(from, to)
      @graph.add_edge(from, to, yield(from, to)) if add?
    end

  end

  class BinomialDigraphGenerator < BinomialGraphGenerator

    private

    def add_edge(from, to)
      @graph.add_edge(from, to, yield(from, to)) if add?
      @graph.add_edge(to, from, yield(to, from)) if add?
    end

    def build_graph
      super(DataStructure::Graph::Digraph)
    end

  end

  def self.binomial_generator(size, rate = 0.5, kind = :graph, &block)
    if kind == :digraph
      BinomialDigraphGenerator.new(size, rate).generate(&block)
    else
      BinomialGraphGenerator.new(size,rate).generate(&block)
    end
  end

end