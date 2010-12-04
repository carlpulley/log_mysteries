#    Log Mysteries: partial answer for Honeynet challenge
#    Reference:
# Reference:  http://honeynet.org/challenges/2010_5_log_mysteries  http://honeynet.org/challenges/2010_5_log_mysteries
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

Answer::Application.routes.draw do
  get "honeynet/index"
  get "research/stop_badware_lookup" => "research#stop_badware_lookup"
  get "research/blacklist_lookup" => "research#blacklist_lookup"

  match 'research/by' => "research#index", :chapter => "by"
  
  match 'research/web_server/rss/:subsection' => "research#index", :chapter => "web_server", :section => "rss", :subsection => /\d+\.\d+\.\d+\.\d+/
  
  match ':controller(/:chapter(/:section(/:subsection)))' => '#index'
  
  root :to => "report#index"
end
