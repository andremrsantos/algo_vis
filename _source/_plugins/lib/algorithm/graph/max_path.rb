require 'data/graph'

module Algorithm::Graph
  INFINITY = 1/0.0

  def self.critical_path(graph)
    CriticalPathMethod.new(graph).find
  end

  class CriticalPathMethod

    attr_reader :graph

    def initialize(graph)
      unless graph.kind_of? DataStructure::Graph::Digraph
        raise ArgumentError, 'Works only with digraph'
      end

      @graph = graph
      nodes  = graph.nodes
      graph.add_node(:source)
      graph.get(:source)[:duration] = 0
      graph.add_node(:exit)
      graph.get(:exit)[:duration]   = 0

      nodes.each do |node|
        graph.add_edge(:source, node) if graph.indegree(node) == 0
        graph.add_edge(node, :exit)   if graph.outdegree(node) == 0
      end

    end

    def find
      reset

      stack_forward = [:source]
      stack_backward= []

      set_early(:source, 0)

      until stack_forward.empty?
        node = stack_forward.pop
        graph.adjacent(node).each do |adj|
          harden(node, adj)
          stack_forward  << adj
          stack_backward << [node, adj]
        end
      end

      set_late(:exit, early_end(:exit))

      until stack_backward.empty?
        from, to = stack_backward.pop
        soften(from, to)
      end

      self
    end

    def critical
      expand(:source)
    end

    def clean
      graph.remove_node(:source)
      graph.remove_node(:exit)
    end

    def to_s
      "<Critical Path Methods>\n" << @activities.map {|node, _| node(node)}.
          join("\n")
    end

    private

    def reset
      @activities = {}
      graph.each_node do |node|
        @activities[node] = {
          duration: graph.get(node)[:duration],
          early_start: -1, early_end: -1,
          late_start:  100000000, late_end:  100000000 }
      end
    end

    def harden(from, to)
      set_early(to, early_end(from)) if early_end(from) > early_start(to)
    end

    def soften(from, to)
      if late_end(from) > late_start(to)
        set_late(from, late_start(to))
      end
    end

    def set_early(node, at)
      duration = duration(node)
      get(node)[:early_start] = at
      get(node)[:early_end]   = at + duration
    end

    def set_late(node, at)
      duration = duration(node)
      get(node)[:late_end] = at
      get(node)[:late_start] = at - duration
    end

    def expand(node)
      if free(node) == 0
        return [[node]] if node == :exit
        paths = []
        graph.adjacent(node).each do |adj|
          if expansion = expand(adj)
            expansion.each {|path| paths << path.unshift(node)}
          end
        end
        paths
      else
        nil
      end
    end

    def get(node)
      @activities[node]
    end

    def early_start(node)
      get(node)[:early_start]
    end

    def early_end(node)
      get(node)[:early_end]

    end

    def late_start(node)
      get(node)[:late_start]
    end

    def late_end(node)
      get(node)[:late_end]
    end

    def duration(node)
      get(node)[:duration]
    end

    def free(node)
      late_end(node) - early_end(node)
    end

    def node(node)
      "Node %6s (%03d)\n early: %3d -- %3d\n late:  %3d -- %3d\n free:  %3d"% [
          node, duration(node),
          early_start(node), early_end(node),
          late_start(node), late_end(node),
          free(node)]
    end

  end

end
