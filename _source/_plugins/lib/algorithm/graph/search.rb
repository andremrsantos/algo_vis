require 'data/graph'

module Algorithm::Graph

  def self.depth_first_search(graph, order = graph.nodes)
    DepthFirstSearch.new(graph, order).search
  end

  def self.bread_first_search(graph, order = graph.nodes)
    BreadFirstSearch.new(graph, order).search
  end

  def self.min_path_from(node, graph)
    bread_first_search(graph, [node].concat(graph.nodes))
  end

  class SearchBase

    attr_reader :graph, :time

    def initialize(graph, visit_order = graph.nodes)
      unless graph.kind_of? DataStructure::Graph::GraphBase
        raise ArgumentError 'only works on Graphs'
      end

      @graph = graph
      @visit_order = visit_order
    end

    def search
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

  class BreadFirstSearch < SearchBase

    def search
      init color: :white, distance: 0

      each_node do |node|
        visit(node)
      end

      self
    end

    private

    def visit(node)
      return nil unless get(node)[:color] == :white

      queue = [node]

      until queue.empty?
        node = queue.shift

        enter_node(node)
        exit_node(node)

        graph.adjacent(node).collect do |edge|
          nxt = edge.other(node)
          if get(nxt)[:color] == :white
            update(nxt, node)
            queue << nxt
          end
        end
      end

    end

    def update(node, parent)
      get(node)[:color] = :grey
      get(node)[:parent] = parent
      get(node)[:distance] = get(parent)[:distance] + 1
    end

  end

  class DepthFirstSearch < SearchBase

    def search
      init color: :white, parent: nil

      each_node { |node| visit(node) }

      self
    end

    private

    def visit(node)
      return nil unless get(node)[:color] == :white

      enter_node(node)

      graph.adjacent(node).each do |edge|
        nxt = edge.other(node)
        get(nxt)[:parent] = node if visit(nxt)
      end

      exit_node(node)
    end

  end

end