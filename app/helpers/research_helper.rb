#    Log Mysteries: partial answer for Honeynet challenge
#    Reference: http://honeynet.org/challenges/2010_5_log_mysteries
#    Copyright (C) 2010  Dr. Carl J. Pulley
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

module ResearchHelper
  def ubuntu_packages(debian_package, timeout=1)
    url = "https://launchpad.net/ubuntu/+search?text=#{debian_package}"
    begin
      page = Nokogiri::HTML(open(url).read)
    rescue
      sleep(timeout)
      retry
    end
    result = []
    page.css("#search-results ul.exact-matches li").each do |exact_match|
      ubuntu_package = exact_match.at_css(".search-result-link").text.strip
      releases = exact_match.at_css(".summary").at_xpath("p[starts-with(text(), 'Available in:')]").text.strip.split("\n").last.split(",").map { |r| r.strip }
      result << { :debian => debian_package, :ubuntu => ubuntu_package, :releases => releases }
    end
    result
  end
  
  def ubuntu_versions(release, ubuntu_package, timeout=1)
    url = "https://launchpad.net/ubuntu/#{release}/+source/#{ubuntu_package}"
    begin
      page = Nokogiri::HTML(open(url).read)
    rescue
      sleep(timeout)
      retry
    end
    result = []
    page.css("#portlet-releases .portletContent li").each do |version|
      result << version.at_css("a").text.strip
    end
    result
  end
  
  def ubuntu_repository_data(debian_package)
    result = []
    ubuntu_packages(debian_package).each do |pkg|
      versioning_data = {}
      pkg[:releases].each do |release|
        versioning_data[release] = ubuntu_versions(release, pkg[:ubuntu])
      end
      pkg[:releases] = versioning_data
      result << pkg
    end
    result
  end
  
  def ubuntu_releases(debian_package, version)
    data = ubuntu_repository_data(debian_package)
    data.map { |d| d[:releases].select { |k,v| v.member? version }.keys }
  end
end
