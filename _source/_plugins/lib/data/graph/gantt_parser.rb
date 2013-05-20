require 'whittle'
require 'algorithm/graph'

module DataStructure::Graph

  class GanttParser < Whittle::Parser
    rule(:wsp   => /\s+/).skip!

    rule(',')
    rule('-')

    rule(:int   => /(-|)\d+/).as { |num| num.to_i }
    rule(:word  => /[\w_][\w_\d]*/)

    rule(:label) do |r|
      r[:word]
      r[:int]
    end

    rule(:dependency) do |r|
      r[:label].as {|word| [word]}
      r[:dependency, ',', :label].as {|dep, _, word| dep << word}
      r['-'].as { [] }
    end

    rule(:job) do |r|
      r[:label, :dependency, :int].as do |node, deps, cost|
        { node: node, deps: deps, cost: cost}
      end
    end

    rule(:jobs) do |r|
      r[:job].as { |job| [job] }
      r[:jobs, :job].as { |arr, job| arr << job}
    end

    rule(:build) do |r|
      r[:jobs].as do |jobs|
        graph = Digraph.new
        jobs.each do |job|
          graph.add_node(job[:node])
          job[:deps].each { |dep| graph.add_edge(dep, job[:node]) }
          graph.get(job[:node])[:duration] = job[:cost]
        end
        graph
      end
    end

    start(:build)

    private

    def self.get_graph
      @graph ||= Digraph.new
    end

  end

  def self.gantt_load(graph)
    lines = case graph
            when File   then graph.readlines.join
            when Array  then graph.join
            when String then graph
            end

    GanttParser.new.parse(lines)
  end

  def self.gantt_dump(graph)
    topological = Algorithm::Graph.topological_sort(graph)
    transpose   = graph.transpose
    topological.map do |node|
      "%s\t%s\t%02d" % [ node,
                         transpose.adjacent(node).join(','),
                         transpose.get(node)[:duration]]
    end.join("\n")
  end

end