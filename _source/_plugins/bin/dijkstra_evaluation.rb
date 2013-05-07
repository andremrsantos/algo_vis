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
  fibo: -> { Algorithm::Graph::DijkstraMinPath.
              new(graph, DataStructure::Heap::FibonacciHeap).find(1) },
  bin:  -> { Algorithm::Graph::DijkstraMinPath.
              new(graph, DataStructure::Heap::BinaryHeap).find(1) },
  vec:  -> { Algorithm::Graph::DijkstraMinPath.
          new(graph, DataStructure::PriorityQueue::VectorQueue).find(1) }
}

sample_report= File.open(folder + '/fixed_size_report.tab', 'w')
avg_report   = File.open(folder + '/fixed_size.tab', 'w')

# Fixed size
(20..500).each do |n|
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

sample_report= File.open(folder + '/fixed_order_report.tab', 'w')
avg_report   = File.open(folder + '/fixed_order.tab', 'w')

# Fixed order
(20..500).each do |n|
  graph = Algorithm::Graph::limited_edges_generator(50, n, :digraph)

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