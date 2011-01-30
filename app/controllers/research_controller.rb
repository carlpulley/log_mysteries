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
    if params[:chapter]
      if params[:chapter] == "by"
        @data = Sudo.scoped
        
        @data = @data.tagged_with(params[:tagged]) if params[:tagged]
        
        @label = ""
        @path = ""
        render "index"
      else
        
        @data = case params[:chapter]
          when "debtags"
            Sudo.command("")
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
