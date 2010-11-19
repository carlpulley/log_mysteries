#    Log Mysteries: partial answer for Honeynet challenge (see http://honeynet.org/challenges/2010_5_log_mysteries)
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
      
      if params[:chapter] == "scan"
        def map_to_hash(data)
          data.map { |d| { :ip_address => d.ip_address.value, :request_count => d.ip_address.apache_accesses.count + d.ip_address.apache_errors.count, :asn => d.ip_address.asn || "", :cc => d.ip_address.cc || "", :blacklists => d.ip_address.blacklists.map { |b| { :site => b.site, :status => b.status } } } }
        end
        @data = map_to_hash ApacheAccess.tagged_with(["scan", params[:section]]).order(:observed_at).all
      end
      
      if params[:chapter] == "bot"
        def map_to_hash(data)
          data.map { |d| { :ip_address => d.ip_address.value, :request_count => d.ip_address.apache_accesses.count + d.ip_address.apache_errors.count, :asn => d.ip_address.asn || "", :cc => d.ip_address.cc || "", :blacklists => d.ip_address.blacklists.map { |b| { :site => b.site, :status => b.status } } } }
        end
        @data = map_to_hash ApacheAccess.tagged_with("bot").user_agent(params[:section]).order(:observed_at).all
      end
      
      if params[:chapter] == "loading" and params[:section] == "requests"
        def map_to_hash(data)
          data.map { |t, c| { :observed_at => t, :num_requests => c } }
        end
        @data = map_to_hash ApacheAccess.where(:result => 200).group(:observed_at).order(:observed_at).count
      end
      
      if params[:chapter] == "loading" and params[:section] == "rss"
        def map_to_hash(data)
          data.map { |d| { :id => d.id, :observed_at => d.observed_at.to_f, :observed_at_str => d.observed_at.in_time_zone('Pacific Time (US & Canada)').strftime("%d/%b/%Y %H:%M:%S %z"), :response_size => d.bytes, :processing_time => d.processing_time } }
        end
        @data = map_to_hash ApacheAccess.tagged_with("rss").order(:observed_at).all
      end
      
      if params[:chapter] == "loading" and params[:section] == "static"
        def map_to_hash(data)
          data.map { |d| { :id => d.id, :observed_at => d.observed_at.to_f, :observed_at_str => d.observed_at.in_time_zone('Pacific Time (US & Canada)').strftime("%d/%b/%Y %H:%M:%S %z"), :transfer_speed => d.transfer_speed/(10**6) } }
        end
        @data = map_to_hash ApacheAccess.tagged_with("static").group(:observed_at).select('apache_accesses.id', :observed_at, 'sum(cast(bytes*1000000 as float))/sum(cast(processing_time as float)) as transfer_speed').order(:observed_at).all
      end
      
      if params[:chapter] == "loading" and params[:section] == "out_of_order"
        def map_to_hash(data)
          result = []
          last_entry = nil
					data.each do |entry|
						unless last_entry.nil?
							if last_entry.observed_at > entry.observed_at
							  result << entry
							end
						end
						last_entry = entry
					end
					result.map_with_index { |d, i| { :log_name => d.name, :observed_at => d.observed_at, :id => d.id, :position => i } }
        end
        @data = map_to_hash(ApacheAccess.where(:name => "www-access.log").select(:id, :observed_at, :name).all) + map_to_hash(ApacheAccess.where(:name => "www-media.log").select(:id, :observed_at, :name).all) + map_to_hash(ApacheError.select(:id, :observed_at, '"www-error.log" as name').all) 
      end
      
      if params[:chapter] == "wordpress" and params[:section] == "plugin"
        def map_to_hash(data)
          data.map { |m| { :request_method => m.apache_access.http_method, :request_name => m.apache_access.http_url, :request_size => m.apache_access.bytes, :request_status => m.apache_access.result, :archive_name => m.archive_content.name, :archive_size => m.archive_content.size, :partial_match => m.tag_list.member?("basename") } }
        end
        @data = map_to_hash Match.type(params[:subsection]).file.all
      end
      
      if params[:chapter] == "web_server" and params[:section] == "rss"
        def map_to_hash(data)
          data.map_with_index { |d, i| { :position => i, :id => d.id, :observed_at => d.observed_at.to_f, :ip_address => d.ip_address.value, :request_count => d.ip_address.apache_accesses.count + d.ip_address.apache_errors.count, :asn => d.ip_address.asn || "", :cc => d.ip_address.cc || "", :blacklists => d.ip_address.blacklists.map { |b| { :site => b.site, :status => b.status } } } }
        end
        @data = map_to_hash ApacheAccess.tagged_with("rss").ip_address(params[:subsection]).all
      end

      render "research/#{params[:chapter]}/#{params[:section]}/#{params[:subsection]}" if params[:subsection]
      render "research/#{params[:chapter]}/#{params[:section]}" unless params[:subsection]
    elsif params[:chapter]
      @data = ApacheAccess.scoped    
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
        
        render "index"
      else
        
        if params[:chapter] == "ip_address"
          def map_to_hash(data)
            data.map { |ip_address| { :ip_address => ip_address.value, :request_count => ip_address.apache_accesses.count + ip_address.apache_errors.count, :asn => ip_address.asn || "", :cc => ip_address.cc || "", :blacklists => ip_address.blacklists.map { |b| { :site => b.site, :status => b.status } } } }
          end
          @data = map_to_hash IpAddress.all
        end
        
        if params[:chapter] == "wordpress"
          def map_to_hash(data)
            data.map { |m| { :request_method => m.apache_access.http_method, :request_name => m.apache_access.http_url, :request_size => m.apache_access.bytes, :request_status => m.apache_access.result, :archive_name => m.archive_content.name, :archive_size => m.archive_content.size, :partial_match => m.tag_list.member?("basename") } }
          end
          @data = map_to_hash Match.type("wordpress").file.all
        end
        
        # TODO: add in tagging data to help in version accountability/auditing?
        if params[:chapter] == "version"
          def map_to_hash(data)
            data.map { |d| { :http_method => d.http_method, :http_url => $1, :http_status => d.result, :version => $2 } if d.http_url =~ /^(.*?)\?ver=([^&^\s]+$)/ } 
          end
          @data = map_to_hash ApacheAccess.tagged_with(["wordpress", "version"]).all
        end
        
        render "research/#{params[:chapter]}"
      end
    else
      render "index"
    end
  end
end
