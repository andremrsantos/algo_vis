module Algorithm
  module Sort
    ASC = lambda { |a, b| a <= b }
    DSC = lambda { |a, b| b >= a }

    private

    def self.exchange(arr, from, to)
      tmp = arr[from]
      arr[from] = arr[to]
      arr[to] = tmp
    end
  end
end

require 'algorithm/sort/mergesort'