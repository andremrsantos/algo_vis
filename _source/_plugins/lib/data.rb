module DataStructure

  class IndexTakenError < ArgumentError
    def initialize(index='')
      super "The index ##{index} is already taken"
    end
  end

  class NoSuchElementError < IndexError
    def initialize(index='index')
      super "There is no element in the ##{index}"
    end
  end

end

require 'data/heap'
require 'data/list'
require 'data/graph'