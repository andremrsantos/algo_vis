module Algorithm

  module Shuffle

    def self.knuth_shuffle!(arr)
      for i in 0...arr.size
        rnd = rand(i)
        # exchange
        tmp = arr[i]
        arr[i] = arr[rnd]
        arr[rnd] = tmp
      end
      arr
    end

    def self.knuth_shuffle(arr)
      knuth_shuffle!(arr.clone)
    end

  end

end