class ReportController < ApplicationController
  def index
    @log_events = ApacheAccess.scoped
    # FIXME: can't matches and anomalies be implemented using scoped tagging?
    @anomalies = {}
    @matches = {}
    @anomalies[:unknown] = [394].map { |n| ApacheAccess.where(["id in (?)", n]) }
    
    @filename = ""
        
    if params[:chapter] and params[:section]
      render "report/#{params[:chapter]}/#{params[:section]}/#{params[:subsection]}" if params[:subsection]
      render "report/#{params[:chapter]}/#{params[:section]}" unless params[:subsection]
    elsif params[:chapter]
      render "report/#{params[:chapter]}"
    else
      render "index"
    end
  end
end
