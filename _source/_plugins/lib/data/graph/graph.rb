module DataStructure::Graph

  class Graph

    def initialize(implementation = QueueGraph)
      include implementation

      init
    end

  end

end