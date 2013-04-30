module Algorithm::Graph

  class SearchBase

    attr_reader :graph, :time

    def initialize(graph)
      unless graph.kind_of? DataStructure::Graph::Graph
        raise ArgumentError 'only works on Graphs'
      end

      @graph = graph
    end

    def search(node)
      raise NotImplementedError 'Search children must implement this method'
    end

    def search_all
      raise NotImplementedError 'Search children must implement this method'
    end

    def get(node)
      @attrs[node]
    end

    def each_node(&block)
      @visit_order.each(&block)
    end

    alias_method :each, :each_node

    def each_with_attr(&block)
      @attrs.each_pair(&block)
    end

    def to_s
      graph.nodes.inject("<#{self.class}>\n") do |str, node|
        attr = get(node)
        str << "\tNode %5s (%02d/%02d)" % [node, attr[:entry], attr[:exit]]
        str << ' distance: %02d ' % attr[:distance] if attr[:distance]
        str << ' parent: %5s ' % attr[:parent] if attr[:parent]
        str << "\n"
      end
    end

    protected

    def init(default = {})
      @time = 0
      @attrs = {}
      each_node { |node| @attrs[node] = default.clone }
    end

    def time
      @time += 1
    end

    def enter_node(node)
      get(node)[:color] = :grey
      get(node)[:entry] = time
    end

    def exit_node(node)
      get(node)[:color] = :black
      get(node)[:exit] = time
    end

  end

end