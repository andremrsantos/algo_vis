#!/usr/bin/env ruby
LIB_DIR = File.dirname(__FILE__) + '/../lib'
$:.unshift LIB_DIR unless $:.include? LIB_DIR

require 'data/graph'
require 'algorithm/graph'

folder = File.dirname(__FILE__) + '/data/output'

graph  = File.readlines(folder + '/../graph/critical_path.gnt', 'r')
graph  = DataStructure::Graph::gantt_load(graph)

puts Algorithm::Graph::critical_path(graph)
puts

graph  = File.readlines(folder + '/../graph/critical.gnt', 'r')
graph  = DataStructure::Graph::gantt_load(graph)

puts Algorithm::Graph::critical_path(graph)
puts