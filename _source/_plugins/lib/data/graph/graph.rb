module DataStructure::Graph

  class Graph

    def initialize(implementation = QueueGraph)
      self.class.send(:include, implementation)

      init
    end

    def to_s
      nodes.inject("<#{self.class}>\n") do |sb, node|
        sb << 'Node %5s in: %02d out: %02d' % [node,
                                               get_node(node)[:in],
                                               get_node(node)[:out]]
        get(node).each_pair do |att, value|
          sb << "\n\t%5s : %02d" % [att, value]
        end
        sb << "\n"
      end
    end

  end

end