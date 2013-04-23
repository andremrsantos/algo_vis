require 'summary_logger'

module Algorithm::Sort

  def self.merge_sort(arr, &comparator)
    return arr if arr.size <= 1

    comparator ||= ASC

    mid = arr.size/2
    left = arr[0,mid]
    right = arr[mid,arr.size]
    merge(merge_sort(left, &comparator),
          merge_sort(right, &comparator),
          &comparator)
  end

  private

  def self.merge(left, right, &comparator)
    sorted = []

    until left.empty? or right.empty?
      sorted << if (left.first < right.first)
                  left.shift
                else
                  if SummaryLogger.has?(:order_inversion)
                    SummaryLogger.get(:order_inversion)[:counter] += 1
                  end
                  right.shift
                end
    end

    sorted.concat(left).concat(right)
  end

end