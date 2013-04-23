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
graph = File.readlines(
    File.dirname(__FILE__) +'/data/graph/lista03_graph01.txt')
graph = DataStructure::Graph::load(graph, DataStructure::Graph::QueueDigraph)

puts 'Graph G'
puts graph
h_line

puts 'a)'
puts Algorithm::Graph::depth_first_search(graph)

puts 'b)'
puts Algorithm::Graph::strongly_connected(graph)
