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
        @data = ApacheAccess.group(:remote).count.map { |k, v| { :ip_address => k, :request_count => v, :asn => (asn_lookup(k).nil? ? "" : asn_lookup(k)[:asn]), :cc => (asn_lookup(k).nil? ? "" : asn_lookup(k)[:cc]) } } if params[:chapter] == "ip_address"
        # TODO: add in relationships between ApacheAccess and Wordpress model and so get this outer join working!
        @data = ApacheAccess.joins("left outer join archive_contents on apache_accesses.http_url like '@archive_contents.name%'").tagged_with("wordpress").tagged_with("plugin", :exclude => true).where('archive_contents.type' => "WordpressArchive").where('archive_contents.directory' => false).all.map { |d| { :request_name => d.http_url, :request_size => d.bytes, :request_status => d.result, :archive_name => d.name, :archive_size => d.size } } if params[:chapter] == "wordpress"
        # TODO: add in tagging data to help in version accountability/auditing?
        @data = ApacheAccess.tagged_with(["wordpress", "version"]).all.map { |d| { :http_method => d.http_method, :http_url => $1, :http_status => d.result, :version => $2 } if d.http_url =~ /^(.*?)\?ver=([^&^\s]+$)/ } if params[:chapter] == "version"
        
        render "research/#{params[:chapter]}"
      end
    else
      render "index"
    end
  end
end
