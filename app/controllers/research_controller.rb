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
              ApacheAccess.tagged_with("static").group(:observed_at).select('apache_accesses.id', :observed_at, 'sum(cast(bytes*1000000 as float))/sum(cast(processing_time as float)) as transfer_speed').order(:observed_at).all
            when "out_of_order" 
              ApacheAccess.where(:name => "www-access.log").select(:id, :observed_at, :name).all + ApacheAccess.where(:name => "www-media.log").select(:id, :observed_at, :name).all + ApacheError.select(:id, :observed_at, '"www-error.log" as name').all
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
end
