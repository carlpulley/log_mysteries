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
    @log_events = ApacheAccess.scoped
    @anomalies = {}
    @matches = {}
    @matches[:contact_form_7] = ["contact-form-7/styles.css", "contact-form-7/scripts.js"].map { |filename| ApacheAccess.tagged_with("contact-form-7").url("/wp-content/plugins/#{filename}") }
    @matches[:google_analyticator] = ["google-analyticator/external-tracking.min.js"].map { |filename| ApacheAccess.tagged_with("google-analyticator").url("/wp-content/plugins/#{filename}") }
    @matches[:google_syntax_highlighter] = ["google-syntax-highlighter/Styles/SyntaxHighlighter.css", "google-syntax-highlighter/Scripts/shBrushPhp.js", "google-syntax-highlighter/Scripts/shBrushCSharp.js", "google-syntax-highlighter/Scripts/shBrushJScript.js", "google-syntax-highlighter/Scripts/shBrushSql.js", "google-syntax-highlighter/Scripts/shBrushJava.js", "google-syntax-highlighter/Scripts/shCore.js", "google-syntax-highlighter/Scripts/shBrushXml.js", "google-syntax-highlighter/Scripts/shBrushVb.js", "google-syntax-highlighter/Scripts/shBrushPython.js", "google-syntax-highlighter/Scripts/shBrushRuby.js", "google-syntax-highlighter/Scripts/shBrushCpp.js", "google-syntax-highlighter/Scripts/shBrushDelphi.js", "google-syntax-highlighter/Scripts/shBrushCss.js"].map { |filename| ApacheAccess.tagged_with("google-syntax-highlighter").url("/wp-content/plugins/#{filename}") }
    @anomalies[:google_syntax_highlighter] = ["shBrushBash.js"].map { |filename| ApacheAccess.url("/wp-content/plugins/google-syntax-highlighter/Scripts/#{filename}") }
    
    @filename = ""
        
    if params[:chapter] and params[:section]
      if params[:chapter] == "wordpress" and params[:section] == "plugin"
        def map_to_hash(data)
          data.map { |m| { :request_method => m.apache_access.http_method, :request_name => m.apache_access.http_url, :request_size => m.apache_access.bytes, :request_status => m.apache_access.result, :archive_name => m.archive_content.name, :archive_size => m.archive_content.size, :partial_match => m.tag_list.member?("basename") } }
        end
        @data = map_to_hash Match.type(params[:subsection]).file.all
      end
      
      if params[:subsection]
        @log_events = @log_events.tagged_with(params[:section])
      end
      if params[:chapter] == "web_server" and params[:section] == "rss"
        @log_events = @log_events.ip_address(params[:subsection])
      end

      render "research/#{params[:chapter]}/#{params[:section]}/#{params[:subsection]}" if params[:subsection]
      render "research/#{params[:chapter]}/#{params[:section]}" unless params[:subsection]
    elsif params[:chapter]
      if params[:chapter] == "by"
        filename = []
        if params[:tagged]
          @log_events = @log_events.tagged_with(params[:tagged])
          filename << params[:tagged].tr(",", "-")
        end
        @log_events = @log_events.url(params[:url]) if params[:url]
        @log_events = @log_events.user_agent(params[:user_agent]) if params[:user_agent]
        if params[:ip_address]
          @log_events = @log_events.ip_address(params[:ip_address])
          filename << params[:ip_address]
        end
        @log_events = @log_events.referer(params[:referer]) if params[:referer]
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
        @data = ApacheAccess.tagged_with(["wordpress", "version"]).all.map { |d| { :http_method => d.http_method, :http_url => $1, :http_status => d.result, :version => $2 } if d.http_url =~ /^(.*?)\?ver=([^&^\s]+$)/ } if params[:chapter] == "version"
        
        render "research/#{params[:chapter]}"
      end
    else
      render "index"
    end
  end
end
