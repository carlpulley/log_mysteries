module ReportHelper
  def mean(values)
    count = values.size
    values.inject(:+) / count.to_f
  end
  
  def standard_deviation(values)
    Math.sqrt(values.inject(0) { |sum, e| sum + (e - mean(values))**2 } / values.size.to_f)
  end
end
