require 'data/set'

module DataStructure::Graph

  module QueueGraph
    include GraphBase

    def has_edge?(from, to)
      edge = build(from, to)
      adjacent(from).include?(to)
    end

    def get_edge(from, to)
      edge = build(from, to)
      adjacent_edges(from).get(edge)
    end

    def add_node(node)
      raise NodeTakenError, node if has_node?(node)

      @nodes[node] = {
          out: 0,
          in: 0,
          nodes: {},
          edges: DataStructure::Set::Set.new }

      @order += 1
      self
    end

    def remove_node(node)
      raise NoSuchNodeError, node unless has_node?(node)

      @nodes.delete(node)
      pull_edges_to(node)
      @order -= 1
      self
    end

    def add_edge(from, to, weight = 1)
      raise EdgeTakenError.new(from, to) if has_edge?(from, to)

      edge = Edge.new(from, to, weight)

      @size += 1
      append_edge(from, edge)
      append_edge(to, edge)
      self
    end
    alias_method :connect, :add_edge

    def remove_edge(from, to)
      raise NoSuchEdgeError, from, to unless has_edge?(from, to)

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

    def edges
      nodes.inject(DataStructure::Set::Set.new) do |set, node|
        set.merge! adjacent_edges(node)
      end
    end

    private

    def build(from, to, weight = 1)
      Edge.new(from, to, weight)
    end

    def append_edge(node, edge)
      get_node(node)[:out] += 1
      get_node(edge.other(node))[:in] += 1
      get_node(node)[:edges] << edge
    end

    def pull_edge(node, edge)
      set = adjacent_edges(node)
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
      raise NoSuchNodeError, node unless nodes.include? node

      node == @node ? @other : @node
    end

    def <=>(edge)
      unless edge.kind_of? self.class
        raise ArgumentError, 'Compared obj must be an Edge'
      end

      weight <=> edge.weight
    end

    def ==(edge)
      unless edge.kind_of? self.class
        raise ArgumentError, 'Compared obj must be an Edge'
      end

      edge.nodes == [@node, @other]
    end

    alias_method :eql?, :==

    def hash
      @node.hash * 43 + @other.hash * 47
    end

    def to_s
      '{%s, %s : %03.2f}' % [@node, @other, @weight]
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