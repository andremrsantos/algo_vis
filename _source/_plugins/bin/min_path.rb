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

puts Algorithm::Graph::dijkstra_min_path(graph, 's')
puts


graph = File.readlines(File.dirname(__FILE__) + '/data/graph/lista04_05.gpy')
graph = DataStructure::Graph::load(graph)

puts Algorithm::Graph::dijkstra_min_path(graph, 1)
puts

graph = File.readlines(File.dirname(__FILE__) + '/data/graph/floyd_graph.gpy')
graph = DataStructure::Graph::load(graph)

puts Algorithm::Graph::DijkstraMinPath.
         new(graph, DataStructure::Heap::BinaryHeap).find(1)
puts

puts Algorithm::Graph::floyd_marshall_min_path(graph)
puts
