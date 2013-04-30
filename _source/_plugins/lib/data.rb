module DataStructure

  class IndexTakenError < ArgumentError
    def initialize(index='')
      super "'#{index}' taken"
    end
  end

  class NoSuchElementError < IndexError
    def initialize(index='index')
      super "No such #{index}"
    end
  end

end

require 'data/heap'
require 'data/list'
require 'data/graph'