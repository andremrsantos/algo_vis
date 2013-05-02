module DataStructure::Graph

  module GraphBase
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
      adjacent(from).include?(to)
    end

    def get(node)
      get_node(node)[:nodes]
    end

    def nodes
      @nodes.keys
    end

    def each_node(&block)
      nodes.each(&block)
    end

    alias_method :each, :each_node

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
      raise NoSuchNodeError, node unless has_node?(node)

      @nodes[node]
    end

  end

end
