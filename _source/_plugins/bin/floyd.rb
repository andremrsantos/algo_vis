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

graph  = File.readlines(folder + '/../graph/lista04_07.gpy', 'r')
graph  = DataStructure::Graph::load(graph)

def dijkstra_find_all(graph)
  dist = []
  parent=[]
  graph.each_node do |n|
    path = Algorithm::Graph::dijkstra_min_path(graph, n)
    dist << graph.nodes.collect {|n| path.get(n)[:distance]}
    parent << graph.nodes.collect {|n| path.get(n)[:parent]}
  end
  [dist, parent]
end

def bellman_find_all(graph)
  dist = []
  parent=[]
  graph.each_node do |n|
    path = Algorithm::Graph::bellman_ford_min_path(graph, n)
    dist << graph.nodes.collect {|n| path.get(n)[:distance]}
    parent << graph.nodes.collect {|n| path.get(n)[:parent]}
  end
  [dist, parent]
end

process = {
    bellman:  -> { bellman_find_all(graph) },
    dijkstra: -> { dijkstra_find_all(graph) },
    floyd:    -> { Algorithm::Graph::floyd_marshall_min_path(graph) }
}


sample_report= File.open(folder + '/floyd_report.tab', 'w')
avg_report   = File.open(folder + '/floyd.tab', 'w')

process.each_key do |dt|
  avg, sample = Report::Algorithm.report_stat(500, &process[dt])

  Report::Graph.report(graph, avg).add(:dt, dt)
  Report::Graph.report(graph, sample).add(:dt, dt)

  avg_report.puts     avg.join("\t")
  sample_report.puts  sample.join("\t")
end

sample_report.close
avg_report.close