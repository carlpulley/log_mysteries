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
