module Algorithm::Graph

  class BellmanFordMinPath
    include MinPath

    def find(start)
      init distance: INFINITY, parent: nil
      get(start)[:distance] = 0

      (graph.order - 1).times do
        graph.each_edge { |edge| relax(edge) }
      end

      graph.each_edge { |edge| return false if relax(edge) }

      self
    end

  end

  def self.bellman_ford_min_path(graph, source)
    BellmanFordMinPath.new(graph).find(source)
  end

end