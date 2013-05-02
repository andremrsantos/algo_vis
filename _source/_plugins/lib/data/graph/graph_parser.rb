require 'whittle'

module DataStructure::Graph

  class GraphParser < Whittle::Parser
    rule(:wsp   => /\s+/).skip!

    rule('digraph' => /digraph/i ).as { set_type(Digraph) }
    rule('graph'   => /graph/i).as    { set_type(Graph) }
    rule(',')
    rule('[')
    rule(']')
    rule('{')
    rule('}')
    rule(':')

    rule(:int   => /(-|)\d+/).as { |num| num.to_i }
    rule(:float => /(-|)\d*\.\d+/).as { |num| num.to_f }
    rule(:word  => /[\w_][\w_\d]*/)

    rule(:num) do |r|
      r[:float]
      r[:int]
    end

    rule(:label) do |r|
      r[:word]
      r[:int]
    end

    rule(:edge) do |r|
      r['{', :label, ',', :label, '}'].as do |_, f,_, t,_|
        get_graph.add_edge(f, t)
      end
      r['{', :label,',', :label, ':', :num, '}'].as do |_, f,_, t,_, w,_|
        get_graph.add_edge(f, t, w)
      end
    end

    rule(:edges) do |r|
      r[:edges, ',', :edge]
      r[:edges, :edge]
      r[:edge]
    end

    rule(:labels) do |r|
      r[:labels, ',', :label].as { |labels, _, l| labels << l }
      r[:label].as {|l| [l] }
    end

    rule(:nodes) do |r|
      r['[', :labels , ']'].as do |_,nodes,_|
        nodes.each{ |n| get_graph.add_node(n) }
      end
      r[:int].as { |num| num.times{|i| get_graph.add_node(i)} }
    end

    rule(:type) do |r|
      r['digraph']
      r['graph']
    end

    rule(:header) do |r|
      r[:type, :nodes, :edges].as { get_graph }
    end

    start(:header)

    private

    def self.set_type(klass)
      @type = klass
    end

    def self.get_graph
      @graph ||= @type.new
    end

  end

  def self.load(graph)
    lines = case graph
            when File   then graph.readlines.join
            when Array  then graph.join
            when String then graph
            end

    GraphParser.new.parse(lines)
  end

  def self.dump(graph)
    sb = graph.class.to_s.gsub(/^.*::/,'')
    sb << "\n[#{graph.nodes.join(',')}]\n"
    graph.edges.inject(sb) { |sb_, e| sb_ << e.to_s << "\n" }
  end

end