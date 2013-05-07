module Report::Algorithm

  def self.report(report = Report::Report.new, &block)
    report.add(:time, Report::realtime(&block))
  end

  def self.report_stat(sample = 100, report = Report::Report.new, &block)
    reports = (1..sample).collect { report(&block) }

    average   = reports.inject(0) do |sum, report|
      sum += report.get(:time)
    end / sample

    deviation = reports.inject(0) do |sum, report|
      sum += (average - report.get(:time))**2
    end
    deviation = Math.sqrt(deviation/sample)

    min = reports.min_by {|report| report.get(:time) }
    max = reports.max_by {|report| report.get(:time) }

    report.add(:avg, average).
        add(:deviation, deviation).
        add(:min, min).
        add(:max, max)
    [report, reports]
  end

end