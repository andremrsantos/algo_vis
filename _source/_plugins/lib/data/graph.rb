require 'data'

module DataStructure

  module Graph

    class NoSuchEdgeError < NoSuchElementError

      def initialize(node_v, node_w)
        super "(#{node_v},#{node_w}) in the Graph"
      end

    end

    class NoSuchNodeError < NoSuchElementError

      def initialize(node)
        super "#{node} in the Graph"
      end

    end

    class NodeTakenError < IndexTakenError; end

    class EdgeTakenError < IndexTakenError

      def initialize(from, to)
        super "{#{from}, #{to}}"
      end

    end
  
  end

end

# require graphs implementations
require 'data/graph/queue_graph'
require 'data/graph/graph'
require 'data/graph/digraph'
require 'data/graph/graph_parser'
