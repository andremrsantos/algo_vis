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

    class EdgeTakenError < IndexTakenError; end

  end

end

# require graphs implementations
require 'data/graph/queue_graph'
require 'data/graph/graph'
require 'data/graph/digraph'