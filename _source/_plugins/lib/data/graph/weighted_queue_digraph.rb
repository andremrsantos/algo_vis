module DataStructure::Graph

  class WeightedQueueDigraph < QueueDigraph

    def add_edge(node_v, node_w, weight = 1)
      raise ArgumentError 'Node already included' if has_edge?(node_v, node_w)
      edge = DirectedEdge.new(node_v, node_w, weight)

      @size += 1
      get_or_add_node(node_v) << edge
    end

    def transpose
      graph = WeightedQueueDigraph.new

      each_edge { |edge| graph.add_edge(edge.to, edge.from, weight) }

      graph
    end

  end

end