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

graph = nil

process = {
    bell:  -> { Algorithm::Graph::bellman_ford_min_path(graph,1) },
    fbell: -> { Algorithm::Graph::fast_bellman_ford_min_path(graph,1) },
    dijk:  -> { Algorithm::Graph::dijkstra_min_path(graph,1) }
}

sample_report= File.open(folder + '/bell_size_report.tab', 'w')
avg_report   = File.open(folder + '/bell_size.tab', 'w')

# Fixed size
(20..300).each do |n|
  graph = Algorithm::Graph::limited_edges_generator(n, 180, :digraph)

  process.each_key do |dt|
    avg, sample = Report::Algorithm.report_stat(100, &process[dt])

    Report::Graph.report(graph, avg).add(:dt, dt)
    Report::Graph.report(graph, sample).add(:dt, dt)

    avg_report.puts     avg.join("\t")
    sample_report.puts  sample.join("\t")
  end
  puts '---%03d---' % n
end
puts "Completed FIXED SIZE"

sample_report= File.open(folder + '/bell_order_report.tab', 'w')
avg_report   = File.open(folder + '/bell_order.tab', 'w')

# Fixed order
(20..300).each do |n|
  graph = Algorithm::Graph::limited_edges_generator(50, n*3, :digraph)

  process.each_key do |dt|
    avg, sample = Report::Algorithm.report_stat(100, &process[dt])

    Report::Graph.report(graph, avg).add(:dt, dt)
    Report::Graph.report(graph, sample).add(:dt, dt)

    avg_report.puts     avg.join("\t")
    sample_report.puts  sample.join("\t")
  end
  puts '---%03d---' % n
end

puts "Completed FIXED ORDER"

sample_report.close
avg_report.close