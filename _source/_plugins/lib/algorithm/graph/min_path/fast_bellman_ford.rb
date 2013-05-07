module Algorithm::Graph

  class FastBellmanFordMinPath < BellmanFordMinPath
    include MinPath

    def find(start)
      init distance: INFINITY, parent: nil
      get(start)[:distance] = 0

      @queue = [start]
      counter = 0
      limit = (graph.order - 1) * graph.size

      until @queue.empty? and counter <= limit
        node = @queue.shift
        graph.adjacent_edges(node).each { |edge| relax(edge) }
        counter += 1
      end

      if counter > limit
        return false
      else
        self
      end
    end

    private

    def update(edge)
      super
      @queue << edge.to unless @queue.contains?(edge.to)
    end

  end

  def self.fast_bellman_ford_min_path(graph, source)
    FastBellmanFordMinPath.new(graph).find(source)
  end

end
