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

    def to_s
      graph.nodes.inject("< #{self.class} >\n") do |str, n|
        str << "Node %5s distance: %3s parent: %5s\n" % [n,
                                                         get(n)[:distance],
                                                         get(n)[:parent]||'-']

      end
    end

  end

  def self.bellman_ford_min_path(graph, source)
    BellmanFordMinPath.new(graph).find(source)
  end

end