require 'data/heap'

module Algorithm::Graph

  class DijkstraMinPath
    include MinPath

    def initialize(graph, pq = DataStructure::Heap::FibonacciHeap)
      super(graph)
      @pq = pq
    end

    def find(start)
      raise ArgumentError unless graph.has_node?(start)

      init distance: INFINITY, parent: nil
      get(start)[:distance] = 0

      @queue = @pq.new()
      graph.each_node{|n| @queue.push(n, get(n)[:distance]) }

      until @queue.empty?
        current = @queue.pop

        graph.adjacent_edges(current).each do |edge|
          relax(edge)
        end
      end

      self
    end

    def to_s
      graph.nodes.inject("< #{self.class} >\n") do |str, n|
        str << "Node %5s distance: %3s parent: %5s\n" % [n,
                                                          get(n)[:distance],
                                                          get(n)[:parent]||'-']

      end
    end

    private

    def update(edge)
      super
      if @queue.contains?(edge.to)
        @queue.change_key(edge.to, get(edge.to)[:distance])
      end
    end

  end

  def self.dijkstra_min_path(graph, start, pq=DataStructure::Heap::FibonacciHeap)
    DijkstraMinPath.new(graph, pq).find(start)
  end

end