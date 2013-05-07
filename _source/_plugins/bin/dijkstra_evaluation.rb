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
sample_report= File.open(folder + '/fixed_size_report.tab', 'w')
avg_report   = File.open(folder + '/fixed_size.tab', 'w')

graph = nil

process = {
  fibo: -> { Algorithm::Graph::DijkstraMinPath.
              new(graph, DataStructure::Heap::FibonacciHeap).find(1) },
  bin:  -> { Algorithm::Graph::DijkstraMinPath.
              new(graph, DataStructure::Heap::BinaryHeap).find(1) },
  vec:  -> { Algorithm::Graph::DijkstraMinPath.
          new(graph, DataStructure::PriorityQueue).find(1) }
}

# Fixed size
(20..1000).each do |n|
  graph = Algorithm::Graph::limited_edges_generator(20, 180, :digraph)

  process.each_key do |dt|
    avg, sample = Report::Algorithm.report_stat(100,
                                                Report::Report.new,
                                                &process[dt])

    avg = Report::Graph.report(graph, avg).add(:type, dt)
    sample = sample.collect do |s|
              Report::Graph.report(graph, s).add(:type, dt).join("\t")
             end

    avg_report.puts avg.join("\t")
    sample_report.puts sample.join("\n")
  end

  puts "-----#{n}-----"
end

sample_report.close
avg_report.close