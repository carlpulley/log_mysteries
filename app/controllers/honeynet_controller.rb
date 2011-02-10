#    Log Mysteries: partial answer for Honeynet challenge
#    Reference: http://honeynet.org/challenges/2010_5_log_mysteries
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

class HoneynetController < ApplicationController
  def index
    @tags = (params[:tagged] ? params[:tagged].split(",") : Sudo.tag_counts_on(:debtags).map { |t| t.name }).sort
    @data = Sudo.scoped
    @data = @data.tagged_with(@tags, :any => true)
    respond_to do |format|
      format.html # index.html.erb
      format.xml do
        render :xml => @data
      end
    end
  end
end
