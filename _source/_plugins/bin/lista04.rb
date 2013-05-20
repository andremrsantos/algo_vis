#!/usr/bin/env ruby
LIB_DIR = File.dirname(__FILE__) + '/../lib'
$:.unshift LIB_DIR unless $:.include? LIB_DIR

require 'data/graph'
require 'data/heap'
require 'data/priority_queue'
require 'algorithm/graph'
require 'algorithm/graph/min_path'
require 'report'

folder = File.dirname(__FILE__) + '/data/output'

graph  = File.readlines(folder + '/../graph/lista04_05.gpy', 'r')
graph  = DataStructure::Graph::load(graph)

puts 'Questão 06-A'
puts Algorithm::Graph::dijkstra_min_path(graph, 1)
puts

graph  = File.readlines(folder + '/../graph/lista04_07.gpy', 'r')
graph  = DataStructure::Graph::load(graph)

puts 'Questão 07-A'
puts Algorithm::Graph::bellman_ford_min_path(graph, 's')
puts

puts 'Questão 08-A'
puts Algorithm::Graph::floyd_marshall_min_path(graph)
puts

graph  = File.readlines(folder + '/../graph/lista04_07D.gpy', 'r')
graph  = DataStructure::Graph::load(graph)

puts 'Questão 07-D'
puts Algorithm::Graph::bellman_ford_min_path(graph, 's')
puts
puts Algorithm::Graph::dijkstra_min_path(graph, 's')
puts

puts 'Questão 08-C'
puts Algorithm::Graph::floyd_marshall_min_path(graph)
puts

