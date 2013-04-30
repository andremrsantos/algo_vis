module Algorithm::Graph

  class DepthFirstSearch < SearchBase

    def initialize(graph)
      super
      init
    end

    def search_all
      init

      each_node { |node| search(node) }
      self
    end

    def search(node)
      visit(node)

      self
    end

    def search!(node)
      init

      search(node)
    end

    private

    def init(hash = {color: :white, parent: nil})
      super
    end

    def visit(node)
      return nil unless get(node)[:color] == :white

      enter_node(node)

      graph.adjacent(node).each do |n|
        get(n)[:parent] = node if visit(n)
      end

      exit_node(node)
    end

  end

  def self.depth_first_search(graph, order = graph.nodes)
    search = DepthFirstSearch.new(graph)
    order.each_node { |n| search.search(n) }
    search
  end

end