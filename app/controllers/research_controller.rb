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
        when "scan" then ApacheAccess.tagged_with(["scan", params[:section]]).order(:observed_at).all
        when "bot" then ApacheAccess.tagged_with("bot").user_agent(params[:section]).order(:observed_at).all
        when "loading" then case params[:section]
          when "requests" then ApacheAccess.where(:result => 200).group(:observed_at).order(:observed_at).count
          when "rss" then ApacheAccess.tagged_with("rss").order(:observed_at).all
          when "static" then ApacheAccess.tagged_with("static").group(:observed_at).select('apache_accesses.id', :observed_at, 'sum(cast(bytes*1000000 as float))/sum(cast(processing_time as float)) as transfer_speed').order(:observed_at).all
          when "out_of_order" then ApacheAccess.where(:name => "www-access.log").select(:id, :observed_at, :name).all + ApacheAccess.where(:name => "www-media.log").select(:id, :observed_at, :name).all + ApacheError.select(:id, :observed_at, '"www-error.log" as name').all
        end
        when "wordpress" then case params[:section]
            when "plugin" then Match.type(params[:subsection]).file.all
          end
        when "web_server" then case params[:section]
            when "rss" then ApacheAccess.tagged_with("rss").ip_address(params[:subsection]).all
          end 
      end

      if params[:subsection]
        @label = "#{params[:subsection]}"
        @url = "#{params[:chapter]}/#{params[:section]}"
        render "research/#{params[:chapter]}/#{params[:section]}/#{params[:subsection]}", :layout => 'research_note'
      else
        @label = "#{params[:section]}"
        @url = "#{params[:chapter]}"
        render "research/#{params[:chapter]}/#{params[:section]}", :layout => 'research_note'
      end
    elsif params[:chapter]
      # TODO: need to make this code more generic and less tied to Apache logs
      @data = Auth.scoped    
      @filename = ""
      if params[:chapter] == "by"
        filename = []
        if params[:tagged]
          @data = @data.tagged_with(params[:tagged])
          filename << params[:tagged].tr(",", "-")
        end
        @data = @data.url(params[:url]) if params[:url]
        @data = @data.user_agent(params[:user_agent]) if params[:user_agent]
        if params[:ip_address]
          @data = @data.ip_address(params[:ip_address])
          filename << params[:ip_address]
        end
        @data = @data.referer(params[:referer]) if params[:referer]
        @filename = (filename.empty? ? "" : "-") + filename.join("-")
        
        @label = ""
        @url = ""
        render "index"
      else
        
        if params[:chapter] == "ip_address"
          def map_to_hash(data)
            data.map { |ip_address| { :ip_address => ip_address.value, :request_count => ip_address.apache_accesses.count + ip_address.apache_errors.count, :asn => ip_address.asn || "", :cc => ip_address.cc || "", :blacklists => ip_address.blacklists.map { |b| { :site => b.site, :status => b.status } } } }
          end
          @data = map_to_hash IpAddress.all
        end
        
        @data = case params[:chapter]
          when "wordpress" then Match.type("wordpress").file.all
          when "version" then ApacheAccess.tagged_with(["wordpress", "version"]).all
          when "file_system" then ApacheAccess.tagged_with(["wordpress", "version"]).all
          when "process" then ApacheAccess.all
          when "cron" then ApacheAccess.url("/wp-cron.php").all
          when "maintenance" then Sudo.scoped
        end
      
        @label = "#{params[:chapter]}"
        @url = ""
        render "research/#{params[:chapter]}", :layout => 'research_note'
      end
    else
      @label = ""
      @url = ""
      render "index"
    end
  end
end
