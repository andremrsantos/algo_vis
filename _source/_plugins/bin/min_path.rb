#!/usr/bin/env ruby
LIB_DIR = File.dirname(__FILE__) + '/../lib'
$:.unshift LIB_DIR unless $:.include? LIB_DIR

require 'algorithm/graph'
require 'algorithm/graph/min_path'
require 'data/graph/graph_parser'

graph = File.readlines(File.dirname(__FILE__) + '/data/graph/dijkstra_graph.gpy')
graph = DataStructure::Graph::load(graph)

puts graph
puts

dij = Algorithm::Graph::dijkstra_min_path(graph, 's')
puts dij
