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
  @@hash = "sha1"
  
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
        when "clocks"
          case params[:section]
            when "10.0.1.2" then ApacheAccess.tagged_with("rss").ip_address(params[:section]).all
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
      if params[:chapter] == "by"
        @data = eval "#{params[:scope]}.scoped" if params[:scope]
        
        @data = @data.tagged_with(params[:tagged]) if params[:tagged]
        if params[:scope] == "ApacheAccess"
          @data = @data.url(params[:url]) if params[:url]
          @data = @data.user_agent(params[:user_agent]) if params[:user_agent]
          @data = @data.ip_address(params[:ip_address]) if params[:ip_address]
          @data = @data.referer(params[:referer]) if params[:referer]
        end
        
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
  
  def stop_badware_lookup
    unless IpAddress.where(:asn => params[:asn]).empty?
      url = "http://www.stopbadware.org/reports/asn/#{params[:asn]}.csv"
      page = open(url).read
      render :json => page.split("\n")[1..-1].map { |l| d = l.split(","); h = {}; h[:date] = DateTime.strptime(d[0], "%Y-%m-%d").to_f; h[:partner] = d[1].to_i; h[:community] = d[2].to_i; h }.to_json
    end
  end
  
  def blacklist_lookup
    ip_address = IpAddress.find_by_value(params[:ip_address])
    unless ip_address.nil?
      uri = URI.parse("http://whatismyipaddress.com/blacklist-check")
      url = "POST #{uri.to_s}?LOOKUPADDRESS=#{ip_address.value}"
      page = add_resource_tagging(uri, Net::HTTP.post_form(uri, {:LOOKUPADDRESS => ip_address.value}).body)
      webpage = WebPage.find_or_create_by_url(url, :page => page.to_s)
      unless webpage.new_record?
        legend = { @@hash => { "eb10c44992742f4653be081db009f453b7c5b646" => "Not Listed", "af1c759f45faee863d9169e20400f0f0a25a3630" => "Listed", "3ebd550fd9ec72bd02601ce2acbb3e408f8fa020" => "Timeout Error", "6c9e96b886b2185fd3a1565cfe5aae3981ec4afb" => "Offline" },
          :ssdeep => { "6:6v/lhPfgl0znDspU9oUyJNf6WRaLERS8ISzFLtVlkLFhaqYBpZajp:6v/7oLo/yXtQYNlkjaZBM" => "Not Listed", "6:6v/lhPfgl0znDsptftJnKSNKyzjB/k2FQWhKvid09kzbanH/NKTNcpP/+p:6v/7oLrtJNP+ud09kzESNj" => "Listed", "6:6v/lhPfgl0znDsptBlc4DETjB/QhDgqwZjLvoqXkaR/O93oKFscGzd0T0GGYnf/N:6v/7oLlMTjyhDwZjLtR/OSKWLaXnf1" => "Timeout Error", "6:6v/lhPfgl0znDsptyO039SoNZIWAX6b2BB/gJ/aRVJFFKttSKo+3/dXsGjP+V1Jh:6v/7oLpYSxfXM2B6VaRVJFFKEp+vSdh" => "Offline" }
        }
        results = page.css("td").select { |item| item.try(:at_css, 'a') && item.try(:at_css, 'img') }.map { |item| puts "#{item}" if item.at_css("a").nil?; [item.at_css("a").text, item.at_css("a")['href'], legend[@@hash][item.at_css("img")[@@hash]]] }
        ip_address.blacklists = results.map { |site, ref, status| Blacklist.find_or_create_by_ip_address_id(ip_address, :status => status, :web_page => webpage, :reference => "http://whatismyipaddress.com#{ref}", :site => site) }
        ip_address.save!
      end
    end
    render :partial => 'ip_blacklist', :object => ip_address.value
  end
  
  private
  
  def add_resource_tagging(uri, html)
    # TODO: need to handle inline CSS import statements, etc.
    page = Nokogiri::HTML(html)
    rsrc_cache = {}
    rsrc_map = { :img => :src, :link => :href, :script => :src, :object => :data }
    rsrc_map.each_pair do |elem, attrib|
      page.xpath("//#{elem}").each do |rsrc|
        unless rsrc[attrib].nil?
          begin
            file_contents = open("#{uri.scheme}://#{uri.host}#{rsrc[attrib]}").read
            rsrc_cache[rsrc[attrib]] ||= eval "Digest::#{@@hash.upcase}.hexdigest(file_contents)"
            # TODO: need to get ssdeep gem building under ruby 1.9.2!
            #if rsrc_cache[rsrc[attrib]].nil?
            #  fuzzy_hash = nil
            #  Ssdeep.fuzzy_hash_buf(file_contents, file_contents.size, fuzzy_hash)
            #  rsrc_cache[rsrc[attrib]] = fuzzy_hash
            #end
            rsrc[@@hash] = rsrc_cache[rsrc[attrib]]
            #rsrc[:ssdeep] = rsrc_cache[rsrc[attrib]]
          rescue OpenURI::HTTPError
            $stderr.print "Failed to download the page resource: #{rsrc}\n"
            next
          end
        end
      end   
    end
    page
  end
  
end
