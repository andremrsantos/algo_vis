module Algorithm::Graph

  def self.has_cycle?(graph)
    CycleSearch.new(graph).cycle?
  end

  class CycleSearch < DepthFirstSearch

    def initialize(graph)
      super
      search
    end

    def cycle?
      @cycle
    end

    private

    def init(hash = {})
      super
      @cycle = false
    end

    def visit(node)
      @cycle ||= get(node)[:color] == :grey
      super if !cycle?
    end

  end

end