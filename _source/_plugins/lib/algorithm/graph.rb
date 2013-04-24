module Algorithm
  module Graph

    class CyclicGraphError < ArgumentError
      def initialize(msg = 'Does not process Cyclic Graph')
        super
      end
    end

  end
end

require 'algorithm/graph/search'
require 'algorithm/graph/topological_sort'
require 'algorithm/graph/connected'
require 'algorithm/graph/cycle'