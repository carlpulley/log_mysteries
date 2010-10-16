class ReportController < ApplicationController
  def index
    @log_events = LogEvent.scoped
    
    if params[:chapter] and params[:section]
      @log_events = @log_events.tagged_with(params[:section]) if params[:subsection]
      @log_events = @log_events.ip_address(params[:subsection]) if params[:chapter] == "web_server" and params[:section] == "rss"
      
      render "report/#{params[:chapter]}/#{params[:section]}/#{params[:subsection]}" if params[:subsection]
      render "report/#{params[:chapter]}/#{params[:section]}" unless params[:subsection]
    elsif params[:chapter]
      if params[:chapter] == "by"
        @log_events = @log_events.tagged_with(params[:tagged]) if params[:tagged]
        @log_events = @log_events.url(params[:url]) if params[:url]
        @log_events = @log_events.user_agent(params[:user_agent]) if params[:user_agent]
        @log_events = @log_events.ip_address(params[:subsection]) if params[:subsection]
        @log_events = @log_events.referer(params[:referer]) if params[:referer]
        
        render "index"
      else
        render "report/#{params[:chapter]}"
      end
    else
      render "index"
    end
  end
end
