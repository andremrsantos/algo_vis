module Report::Graph

  def self.report(graph, report = ReportEntry.new)
    report.add(:type,  Report::simple_name(graph)).
        add(:order, graph.order).
        add(:size,  graph.size)
  end

end