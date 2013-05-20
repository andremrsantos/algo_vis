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

graph  = File.readlines(folder + '/../graph/lista04_07D.gpy', 'r')
graph  = DataStructure::Graph::load(graph)

process = {
    bell:  -> { Algorithm::Graph::bellman_ford_min_path(graph, 's') },
    dijk:  -> { Algorithm::Graph::dijkstra_min_path(graph, 's') }
}

sample_report= File.open(folder + '/_bell_report.tab', 'w')
avg_report   = File.open(folder + '/_bell.tab', 'w')

def record(graph, process, sample_report, avg_report)
  process.each_key do |dt|
    avg, sample = Report::Algorithm.report_stat(100, &process[dt])

    Report::Graph.report(graph, avg).add(:dt, dt)
    Report::Graph.report(graph, sample).add(:dt, dt)

    avg_report.puts     avg.join("\t")
    sample_report.puts  sample.join("\t")
  end
end

edges = []
graph.each_node do |i|
  graph.each_node do |j|
    next if i == j || graph.has_edge?(i,j)
    edges << [i,j]
  end
end

record(graph, process, sample_report, avg_report)
edges.each do |from, to|
  graph.add_edge(from, to, rand * 10)
  record(graph, process, sample_report, avg_report)
  print '|'
end

sample_report.close
avg_report.close