module Algorithm::Graph

  class BreadFirstSearch < SearchBase

    def initialize(graph)
      super
      init
    end

    def search_all
      init

      each_node do |node|
        search(node)
      end
      self
    end

    def search(node)
      visit(node)
      self
    end

    def search!(node)
      init

      search(node)
      self
    end

    private

    def init(hash = { color: :white, disrtance: 0 })
      super
    end

    def visit(node)
      return nil unless get(node)[:color] == :white

      queue = [node]

      until queue.empty?
        node = queue.shift

        enter_node(node)
        exit_node(node)

        queue.concat collect_adjacent(node)
      end

    end

    def collect_adjacent(node)
      adj = []
      graph.adjacent(node).each do |n|
        if get(n)[:color] == :white
          update(n, node)
          adj << n
        end
      end
      adj
    end

    def update(node, parent)
      get(node)[:color] = :grey
      get(node)[:parent] = parent
      get(node)[:distance] = get(parent)[:distance] + 1
    end

  end

  def self.bread_first_search(graph, order = graph.nodes)
    search = BreadFirstSearch.new(graph)
    order.each_node { |n| search.search(n) }
    search
  end

  def self.level_min_path(graph, from, to)
    search = BreadFirstSearch.new(graph).search(from)
    if search.get(to)[:parent].nil?
      'Not reachable'
    else
      path = [to]
      until search.get(path.first)[:parent].nil? || path.first == from
        path.unshift search.get(path.first)[:parent]
      end
    end
  end

end