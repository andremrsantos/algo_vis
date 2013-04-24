#!/usr/bin/env ruby
LIB_DIR = File.dirname(__FILE__) + '/../lib'
$:.unshift LIB_DIR unless $:.include? LIB_DIR

require 'algorithm/graph'

def h_line
  puts
  puts '--' * 10
  puts
end

def question_header(number)
  puts 'Question %02d' % number
  h_line
end

# Iniciando resolução
puts 'Lista de Exercícios 03'
h_line

# 1st Question
question_header(01)
# loading graph
graph01 = File.readlines(
    File.dirname(__FILE__) + '/data/graph/lista03_graph01.txt')
graph01 = DataStructure::Graph::load(graph01, DataStructure::Graph::QueueDigraph)

puts 'Graph G 01'
puts graph01
h_line

puts 'a)'
puts Algorithm::Graph::depth_first_search(graph01)

puts 'b)'
puts Algorithm::Graph::strongly_connected(graph01)

puts 'c)'
puts Algorithm::Graph::has_cycle?(graph01)

puts 'd)'
puts 'Distance to 9 from Node 0'
puts Algorithm::Graph::min_path(0, 9, graph01).inspect

# 2nd Question
h_line
question_header(02)
# loading graph
graph02 = File.readlines(
    File.dirname(__FILE__) + '/data/graph/lista03_graph02.txt')
graph02 = DataStructure::Graph::load(graph02,
                                     DataStructure::Graph::QueueDigraph)

puts 'Graph G 02'
puts graph02
h_line

puts Algorithm::Graph::topological_sort(graph02).join(' - ')

# 3rd Question
h_line
question_header(03)

visit = Algorithm::Graph::topological_sort(graph02)
matrix = graph02.adjacent_matrix(graph02.nodes).collect do |line|
          '|' + line.collect {|el| '%2s' % (el or 0) }.join(' ') + '|'
end.join("\n")
puts matrix

h_line

matrix = graph02.adjacent_matrix(visit).collect do |line|
          '|' + line.collect {|el| '%2s' % (el or 0) }.join(' ') + '|'
end.join("\n")
puts matrix

# 4th Question
h_line
question_header(04)

puts graph02.euler?

