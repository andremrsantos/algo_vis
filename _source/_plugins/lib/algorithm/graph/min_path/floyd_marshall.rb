module Algorithm::Graph

  class FloydMarshallMinPath
    include MinPath

    def find
      init

      graph.each_node do |from|
        graph.each_node do |to|
          graph.each_node {|by| relax(from, by, to) }
        end
      end

      self
    end

    def to_s
      str = "< #{self.class} >\n         \t"
      graph.each_node {|n| str << "%4s  \t" % n }
      str << "\n"

      graph.each_node do |from|
        str << "Node %4s\t" % from
        graph.each_node do |to|
          str << "%2s(%2s)\t" % [distance(from)[to], parent(from)[to] || '-']
        end
        str << "\n"
      end
      str
    end

    private

    def init
      super distance: nil, parent: nil

      # SET ALL EDGES
      graph.each_node do |from|
        get(from)[:distance] = {}
        get(from)[:parent] = {}

        graph.each_node do |to|
          if from == to
            distance(from)[to] = 0
          elsif edge = graph.get_edge(from, to)
            distance(edge.from)[edge.to] = edge.weight
            parent(edge.from)[edge.to]   = edge.from
          else
            distance(from)[to] = INFINITY
          end
        end
      end

    end

    def relax(from, by, to)
      if distance(from)[by] + distance(by)[to] < distance(from)[to]
        update(from, by, to)
      end
    end

    def update(from, by, to)
      distance(from)[to] = distance(from)[by] + distance(by)[to]
      parent(from)[to]   = by
    end

  end

  def self.floyd_marshall_min_path(graph)
    FloydMarshallMinPath.new(graph).find
  end

end