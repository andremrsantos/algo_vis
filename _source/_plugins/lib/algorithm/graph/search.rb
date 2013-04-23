require 'data/graph'

module Algorithm::Graph

  def self.depth_first_search(graph)
    unless graph.kind_of? DataStructure::Graph::GraphBase
      raise ArgumentError 'Must pass a Graph'
    end

    time  = 0
    result = {}

    graph.each_node do |node|
      result[node] = { color: :white }
    end

    graph.each_node do |node|

      if result[node][:color] == :white
        time = depth_visit(graph, node, time, result)
      end

    end

    puts summary(result)
    result
  end

  def self.bread_first_search(graph)
    unless graph.kind_of? DataStructure::Graph::GraphBase
      raise ArgumentError 'Must pass a Graph'
    end

    time  = 0
    result = {}

    graph.each_node do |node|
      result[node] = { color: :white, dist: 0 }
    end

    queue = [graph.nodes.first]

    until queue.empty?
      node = queue.shift
      time = enter_node(node, time, result)

      graph.adjacent(node).each do |edge|
        next_node = edge.other(node)

        if result[next_node][:color] == :white
          result[next_node][:color] = :grey
          result[next_node][:dist]  = result[node][:dist] + 1
          result[next_node][:parent] = node
          queue << next_node
        end
      end

      time = exit_node(node, time, result)
    end

    puts summary(result)
    result
  end

  def self.summary(hash = {})
    str = ''
    hash.each_pair do |node, attrs|
      str << "Node #%4s\n" % node
      attrs.each_pair do |attr, value|
        str << "| %10s -> %10s\n" % [attr, value]
      end
    end
    str
  end

  private

  def self.depth_visit(graph, node, time, result)
    time = enter_node(node, time, result)

    graph.adjacent(node).each do |edge|
      next_node = edge.other(node)

      if result[next_node][:color] == :white
        result[next_node][:parent] = node
        time = depth_visit(graph, next_node, time, result)
      end

    end

    time = exit_node(node, time, result)
  end

  def self.enter_node(node, time, result)
    result[node][:color] = :grey
    time += 1
    result[node][:entry] = time
  end

  def self.exit_node(node, time, result)
    result[node][:color] = :black
    time += 1
    result[node][:exit] = time
  end

end