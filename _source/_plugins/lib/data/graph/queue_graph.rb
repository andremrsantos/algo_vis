require 'data/set'

module DataStructure::Graph

  module QueueGraph
    include Enumerable
    attr_reader :order, :size

    def init
      @nodes = {}
      @order = 0
      @size  = 0
    end

    def empty?
      ! @nodes.nil?
    end

    def has_node?(node)
      ! @nodes[node].nil?
    end

    def has_edge?(from,to)
      ! adjacent(from).include?(to)
    end

    def add_node(node)
      raise NodeTakenError node if has_node?(node)

      @nodes[node] = { out: 0, in: 0, attr: {}, edges: DataStructure::Set.new }
      @order += 1
      self
    end

    def remove_node(node)
      raise NoSuchNodeError node unless has_node?(node)

      @nodes.delete(node)
      pull_edges_to(node)
      @order -= 1
      self
    end

    def get(node)
      get_node(node)[:attr]
    end

    def add_edge(from, to, weight = 1)
      raise EdgeTakenError from, to if has_edge?(from, to)

      add_node(from) unless has_node?(from)
      add_node(to)   unless has_node?(to)

      edge = Edge.new(from, to, weight)

      @size += 1
      append_edge(from, edge)
      append_edge(to, edge)
      self
    end
    alias_method :connect, :add_edge

    def remove_edge(from, to)
      raise NoSuchEdgeError from, to unless has_edge?(from, to)

      edge = Edge.new(from, to)

      @size -= 1
      pull_edge(from, edge)
      pull_edge(to, edge)
      self
    end
    alias_method :disconnect, :remove_edge

    def adjacent(node)
      adjacent_edges(node).collect { |edge| edge.other(node) }
    end

    def adjacent_edges(node)
      get_node(node)[:edges]
    end

    def nodes
      @edges.keys
    end

    def each_node(&block)
      nodes.each(&block)
    end
    alias_method :each, :each_node

    def edges
      nodes.inject(DataStructure::Set.new) do |set, node|
        set.merge! adjacent(node)
      end
    end

    def each_edge(&block)
      edges.each(&block)
    end

    def degree(node)
      get_node(node)[:out]
    end

    def euler?
      each_node do |node|
        return false unless degree(node) % 2 == 0
      end

      true
    end

    def regular?
      degree_ = degree(first)
      each_node do |node|
        return false unless degree(node) == degree_
      end

      true
    end

    private

    def get_node(node)
      raise NoSuchNodeError node unless has_node?(node)

      @nodes[node]
    end

    def append_edge(node, edge)
      get_node(node)[:out] += 1
      get_node(edge.other(node))[:in] += 1
      get_node(node)[:edges] << edge
    end

    def pull_edge(node, edge)
      set = get_node(node)[:edges]
      if set.contains? edge
        get_node(node)[:out] -= 1
        get_node(edge.other(node))[:in] -= 1
        set.remove(edge)
      end
    end

    def pull_edges_to(node)
      each_node do |n|
        pull_edge(n, Edge.new(n, node))
      end
    end

  end

  class Edge
    include Comparable

    attr_reader :weight

    def initialize(node, other, weight = 1)
      @node, @other = if node.hash < other.hash
                        [node, other]
                      else
                        [other, node]
                      end
      @weight = weight
    end

    def nodes
      [@node, @other]
    end

    def either
      @node
    end

    def other(node)
      raise ArgumentError, 'Node not found' unless nodes.include? node

      node == @node ? @other : @node
    end

    def <=>(edge)
      unless edge.kind_of? self.class
        raise ArgumentError, 'Compared obj must be an Edge'
      end

      weight <=> edge.weight
    end

    def ==(edge)
      unless edge.kind_of? Edge
        raise ArgumentError, 'Compared obj must be an Edge'
      end

      edge.edges == [@node, @other]
    end

    def hash
      @node.hash * 43 + @other.hash * 47
    end

    def to_s
      '{%s,%s:%03.2f}' % [@node, @other, @weight]
    end

  end

  class DirectedEdge < Edge

    def initialize(node, other, weight = 1)
      @node = node
      @other = other
      @weight= weight
    end

    def from
      @node
    end

    def to
      @other
    end

  end

end