module DataStructure::Graph

  class WeightedQueueGraph < QueueGraph

    def add_edges(node_v, node_w, weight = 1)
      raise ArgumentError 'Edge already included' if has_edge?(node_v, node_w)
      edge = Edge.new(node_v, node_w, weight)

      @size += 1

      get_or_add_node(node_v) << edge
      get_or_add_node(node_w) << edge unless node_v == node_w
    end

  end

end