module ReportHelper
  def average(values)
    values.sum / values.count.to_f
  end
  
  def mean(values)
    count = values.size
    values.inject(:+) / count.to_f
  end
  
  def standard_deviation(values)
    Math.sqrt(values.inject(0) { |sum, e| sum + (e - mean(values))**2 } / values.size.to_f)
  end
  
  def github_link(location, location_label)
    location_label ||= location
    link_to location_label, "http://github.com/carlpulley/log_mysteries/#{location}"
  end
end
