module ApplicationHelper
  def github_link(location, location_label = nil)
    location_label ||= location
    #link_to location_label, "http://github.com/carlpulley/log_mysteries/#{location}"
    link_to location_label, "file://#{File.expand_path('.')}/#{location}"
  end
end
