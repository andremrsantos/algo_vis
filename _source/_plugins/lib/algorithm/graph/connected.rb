require 'data/graph'

module Algorithm::Graph

  def self.strongly_connected(graph)
    StronglyConnected.new(graph).find
  end

  class StronglyConnected

    attr_reader :graph, :groups

    def initialize(graph)
      unless graph.kind_of? DataStructure::Graph::Digraph
        raise ArgumentError 'Works only with Digraph'
      end

      @graph = graph
    end

    def find
      depth_first = Algorithm::Graph::depth_first_search(graph)
      graph_ = graph.transpose

      nodes = graph.nodes.sort do |a, b|
        -(depth_first.get(a)[:exit] <=> depth_first.get(b)[:exit])
      end

      @groups = ConnectedDepthFirstSearch.new(graph_).search(nodes).groups

      self
    end

    def to_s
      @groups.inject("< #{self.class} >\n") do |str, group|
        str << "\t{ #{group.join(',')} } \n"
      end
    end

    class ConnectedDepthFirstSearch < DepthFirstSearch
      attr_reader :groups

      def search(order)
        init color: :white, parent: nil

        last = @time

        order.each do |node|
          if visit(node)
            @groups << order.find_all do |node|
              get(node)[:exit] and get(node)[:exit].between?(last, @time)
            end
            last = @time + 1
          end
        end

        self
      end

      protected

      def init(hash = {})
        super
        @groups = []
      end
    end

  end

end