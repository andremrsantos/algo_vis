require 'data/graph'

module Algorithm::Graph

  def self.depth_first_search(graph)
    DepthFirstSearch.new(graph).search
  end

  def self.bread_first_search(graph)
    BreadFirstSearch.new(graph).search
  end

  class SearchBase

    attr_reader :graph, :time

    def initialize(graph)
      unless graph.kind_of? DataStructure::Graph::GraphBase
        raise ArgumentError 'only works on Graphs'
      end

      @graph = graph
    end

    def search
      raise NotImplementedError 'Search children must implement this method'
    end

    def get(node)
      @attrs[node]
    end

    def each_node(&block)
      @attrs.each_key(&block)
    end

    alias_method :each, :each_node

    def each_with_attr(&block)
      @attrs.each_pair(&block)
    end

    def to_s
      str = "<#{self.class}>\n"
      each_with_attr do |node, attr|
        str << "\tNode %5s (%02d/%02d) " % [node, attr[:entry], attr[:exit]]
        str << 'level: %02d ' % attr[:level] if attr[:level]
        str << 'parent: %5s ' % attr[:parent] if attr[:parent]
        str << "\n"
      end
      str
    end

    protected

    def init(default = {})
      @time = 0
      @attrs = {}
      graph.each_node { |node| @attrs[node] = default.clone }
    end

    def pass_time
      @time += 1
    end

    def enter_node(node)
      get(node)[:color] = :grey
      get(node)[:entry] = pass_time
    end

    def exit_node(node)
      get(node)[:color] = :black
      get(node)[:exit] = pass_time
    end

  end

  class BreadFirstSearch < SearchBase

    def search
      init color: :white

      graph.each_node do |node|
        visit(node) if get(node)[:color] == :white
      end

      self
    end

    private

    def visit(node)
      queue = [node]

      until queue.empty?
        enter_node(node)
        exit_node(node)

        queue << enqueue(node)
      end

    end

    def enqueue(node)
      graph.adjacent(node).collect do |edge|
        nxt = edge.other(node)
        if get(nxt)[:color] == :white
          get(nxt)[:color] = :grey
          get(nxt)[:parent] = node
          get(nxt)[:distance] = get(node)[:distance] + 1
          nxt
        end
      end.compact
    end

  end

  class DepthFirstSearch < SearchBase

    def search
      init color: :white, parent: nil

      graph.each_node do |node|
        visit(node)
      end

      self
    end

    private

    def visit(node)
      return false unless get(node)[:color] == :white

      enter_node(node)

      graph.adjacent(node).each do |edge|
        nxt = edge.other(node)
        get(nxt)[:parent] = node if visit(nxt)
      end

      exit_node(node)
    end

  end

end