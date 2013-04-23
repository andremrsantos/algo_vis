LIB_DIR = File.dirname(__FILE__) + '/../lib'
$:.unshift LIB_DIR unless $:.include? LIB_DIR

require 'algorithm/sort'
require 'summary_logger'

DATA_DIR = File.dirname(__FILE__) + '/data/'

def q01
  puts 'loading data vector...'
  vector = File.open(DATA_DIR + 'VetorInteiros.txt').collect { |line| line.to_i }

  puts 'Sorting...'
  if SummaryLogger.has? :order_inversion
    SummaryLogger.get(:order_inversion)[:counter] = 0
  else
    SummaryLogger.add(:order_inversion, counter: 0)
  end
  Algorithm::Sort::merge_sort(vector)

  puts 'Counting Events...'
  puts SummaryLogger.get(:order_inversion)[:counter]
end