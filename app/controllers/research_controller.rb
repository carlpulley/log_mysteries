#    Log Mysteries: partial answer for Honeynet challenge
#    Reference:  http://honeynet.org/challenges/2010_5_log_mysteries
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

class ResearchController < ApplicationController
  def index
    
    if params[:chapter] and params[:section]
      
      @data = case params[:chapter]
        when "scan" 
          ApacheAccess.tagged_with(["scan", params[:section]]).order(:observed_at).all
        when "bot" 
          ApacheAccess.tagged_with("bot").user_agent(params[:section]).order(:observed_at).all
        when "loading" 
          case params[:section]
            when "requests" 
              ApacheAccess.where(:result => 200).group(:observed_at).order(:observed_at).count
            when "rss" 
              ApacheAccess.tagged_with("rss").order(:observed_at).all
            when "static" 
              ApacheAccess.tagged_with("static").group(:observed_at).select(['apache_accesses.id', :observed_at, 'sum(cast(bytes*1000000 as float))/sum(cast(processing_time as float)) as transfer_speed']).order(:observed_at).all
            when "out_of_order" 
              ApacheAccess.where(:name => "www-access.log").select([:id, :observed_at, :name]).all + ApacheAccess.where(:name => "www-media.log").select([:id, :observed_at, :name]).all + ApacheError.select([:id, :observed_at, '"www-error.log" as name']).all
          end
        when "wordpress" 
          case params[:section]
            when "plugin" then Match.type(params[:subsection]).file.all
          end
        when "web_server" 
          case params[:section]
            when "rss" then ApacheAccess.tagged_with("rss").ip_address(params[:subsection]).all
          end 
      end

      if params[:subsection]
        @label = "#{params[:subsection]}"
        @path = "#{params[:chapter]}/#{params[:section]}"
        render "research/#{params[:chapter]}/#{params[:section]}/#{params[:subsection]}", :layout => 'research_note'
      else
        @label = "#{params[:section]}"
        @path = "#{params[:chapter]}"
        render "research/#{params[:chapter]}/#{params[:section]}", :layout => 'research_note'
      end
    elsif params[:chapter]
      # TODO: need to make this code more generic and less tied to Apache logs
      if params[:chapter] == "by"
        @data = ApacheAccess.scoped    
        
        @data = @data.tagged_with(params[:tagged]) if params[:tagged]
        @data = @data.url(params[:url]) if params[:url]
        @data = @data.user_agent(params[:user_agent]) if params[:user_agent]
        @data = @data.ip_address(params[:ip_address]) if params[:ip_address]
        @data = @data.referer(params[:referer]) if params[:referer]
        
        @label = ""
        @path = ""
        render "index"
      else
        
        @data = case params[:chapter]
          when "ip_address"
            IpAddress.all
          when "wordpress"  
            Match.type("wordpress").file.all
          when "version"  
            ApacheAccess.tagged_with(["wordpress", "version"]).all
          when "file_system"  
            ApacheAccess.tagged_with(["wordpress", "version"]).all
          when "process"  
            ApacheAccess.all
          when "unknown"  
            ApacheAccess.all
          when "cron"  
            ApacheAccess.url("/wp-cron.php").all
          when "maintenance"  
            Sudo.scoped
        end
      
        @label = "#{params[:chapter]}"
        @path = ""
        render "research/#{params[:chapter]}", :layout => 'research_note'
      end
    else
      @label = ""
      @path = ""
      render "index"
    end
  end
  
  # FIXME: function should only be called in response to update events on a record
  def stop_badware_lookup
    # TODO: place contents of http://www.stopbadware.org/reports/asn/#{self.asn}.csv into DB
    url = "http://www.stopbadware.org/reports/asn/#{self.asn}.csv"
    page = open(url).read
    if page =~ /^Date,Partner Reports,Community Reports\n/
      webpage = WebPage.find_or_create_by_url("GET #{url}", :page => page)
      webpage.page.split("\n").each do |line|
        
      end
    end
  end
  
  # FIXME: function should only be called in response to update events on a record
  def blacklist_lookup
    uri = URI.parse("http://whatismyipaddress.com/blacklist-check")
    url = "POST #{uri.to_s}?LOOKUPADDRESS=#{self.value}"
    page = add_resource_tagging(uri, Net::HTTP.post_form(uri, {:LOOKUPADDRESS => self.value}).body)
    webpage = WebPage.find_or_create_by_url(url, :page => page.to_s)
    legend = { @@hash => { "eb10c44992742f4653be081db009f453b7c5b646" => "Not Listed", "af1c759f45faee863d9169e20400f0f0a25a3630" => "Listed", "3ebd550fd9ec72bd02601ce2acbb3e408f8fa020" => "Timeout Error", "6c9e96b886b2185fd3a1565cfe5aae3981ec4afb" => "Offline" },
      :ssdeep => { "6:6v/lhPfgl0znDspU9oUyJNf6WRaLERS8ISzFLtVlkLFhaqYBpZajp:6v/7oLo/yXtQYNlkjaZBM" => "Not Listed", "6:6v/lhPfgl0znDsptftJnKSNKyzjB/k2FQWhKvid09kzbanH/NKTNcpP/+p:6v/7oLrtJNP+ud09kzESNj" => "Listed", "6:6v/lhPfgl0znDsptBlc4DETjB/QhDgqwZjLvoqXkaR/O93oKFscGzd0T0GGYnf/N:6v/7oLlMTjyhDwZjLtR/OSKWLaXnf1" => "Timeout Error", "6:6v/lhPfgl0znDsptyO039SoNZIWAX6b2BB/gJ/aRVJFFKttSKo+3/dXsGjP+V1Jh:6v/7oLpYSxfXM2B6VaRVJFFKEp+vSdh" => "Offline" }
    }
    results = page.css("td").select { |item| item.try(:at_css, 'a') && item.try(:at_css, 'img') }.map { |item| puts "#{item}" if item.at_css("a").nil?; [item.at_css("a").text, item.at_css("a")['href'], legend[@@hash][item.at_css("img")[@@hash]]] }
    results.each do |site, ref, status|
      self.blacklists << Blacklist.find_or_create_by_site(site, :status => status, :web_page => webpage, :reference => ref)
    end
  end
  
end
