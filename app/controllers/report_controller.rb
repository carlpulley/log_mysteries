class ReportController < ApplicationController
  def index
    @log_events = LogEvent.scoped
    @filename = ""
        
    if params[:chapter] and params[:section]
      if params[:subsection]
        @log_events = @log_events.tagged_with(params[:section])
      end
      if params[:chapter] == "web_server" and params[:section] == "rss"
        @log_events = @log_events.ip_address(params[:subsection])
      end

      render "report/#{params[:chapter]}/#{params[:section]}/#{params[:subsection]}" if params[:subsection]
      render "report/#{params[:chapter]}/#{params[:section]}" unless params[:subsection]
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
        render "report/#{params[:chapter]}"
      end
    else
      render "index"
    end
  end
end
