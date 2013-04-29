require 'whittle'

module DataStructure::Graph

  class GraphParser < Whittle::Parser
    rule(:label)
    rule(:number)
    rule(:list)

    rule(:edge)
    rule(:definition)

  end

end