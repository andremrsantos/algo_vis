module DataStructure::Graph

  class Digraph < Graph

    def add_edge(from, to)
      raise EdgeTakenError from, to if has_edge?(from, to)

      add_node(from) unless has_node?(from)
      add_node(to)   unless has_node?(to)

      edge = DirectedEdge.new(from, to)

      @size += 1
      append_edge(from, edge)
      self
    end

    def remove_edge(from, to)
      raise NoSuchEdgeError from, to unless has_edge?(from, to)

      edge = DirectedEdge.new(from, to)

      pull_edge(from, edge)
      self
    end

    def indegree(node)
      get_node(node)[:in]
    end

    def outdegree(node)
      degree(node)
    end

    def transpose
      graph = Digraph.new(@implementation)

      each_edge { |edge| graph.add_edge(edge.to, edge.from) }

      graph
    end

  end

end