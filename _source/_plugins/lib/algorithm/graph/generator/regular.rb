require 'algorithm/shuffle'

module Algorithm::Graph

  class RegularDigraphGenerator
    include GraphGenerator

    def initialize(size, links)
      raise ArgumentError 'Unreachable condition' if links > size - 1
      super(size)
      @links = links
    end

    def generate(&block)
      block ||= -> { rand * 10 }

      build_graph
      nodes = Shuffle::knuth_shuffle(@graph.nodes)

      (0...nodes.size).each do |i|
        add_edge(i, nodes)
      end

      @graph
    end

    private

    def add_edge(at, order)
      (1..@links).each do |i|
        one = order[at]
        other = order[at-i]
        @graph.add_edge(one, other, yield(one, other))
      end
    end
  end

  def self.regular_generator(size, links, &block)
    RegularDigraphGenerator.new(size, links, &block)
  end

end