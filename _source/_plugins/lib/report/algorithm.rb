module Report::Algorithm

  def self.report(report = Report::ReportEntry.new, &block)
    report.add(:time, Report::realtime(&block))
  end

  def self.report_stat(sample = 100, report = Report::Report.new, &block)
    samples = Report::Report.new
    (1..sample).each { samples.append report(&block) }

    average = samples.inject(0) do |sum, report|
                sum += report.get(:time)
              end
    average = average.to_f/sample

    st_dev = samples.inject(0) do |sum, report|
                  sum += (average - report.get(:time))**2
                end
    st_dev = Math.sqrt(st_dev/sample)

    min = samples.min_by {|report| report.get(:time) }.get(:time)
    max = samples.max_by {|report| report.get(:time) }.get(:time)

    entry = Report::ReportEntry.new

    entry.add(:sample, sample).
        add(:avg, average).
        add(:st_dev, st_dev).
        add(:min, min).
        add(:max, max)

    report.append(entry)
    [report, samples]
  end

end