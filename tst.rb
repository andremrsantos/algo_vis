LIB_DIR = File.dirname(__FILE__) + '/_source/_plugins/lib'
$:.unshift LIB_DIR unless $:.include? LIB_DIR

require 'data/graph'
require 'data/graph/graph_parser'

lines = File.readlines('graph.gpy')

puts lines.join
puts
graph = DataStructure::Graph::load(lines.join)
puts graph
puts
puts DataStructure::Graph::dump(graph)
