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

namespace :tag do
  namespace :with do
    task :debtags => :environment do 
      Sudo.select { |s| s.message.keys.member? :command }.each do |event|
        command = event.message[:command]
        if command =~ /^([^ ]+)/
          event.command_list << $1 
        end
        debian_tags = event.debian_tags
        if debian_tags != {}
          event.debtag_list << debian_tags.keys.inject(debian_tags.first.last) { |ts, k1| ts.select { |k2| debian_tags[k1].member? k2 } } # encodes: event has debtags common to *all* packages
          event.package_list << debian_tags.keys # encodes: event belongs to *some* debian_tags package
        end
        event.user_list << event.message[:user]
        event.pwd_list << event.message[:pwd]
        event.tty_list << event.message[:tty]
        event.save!
      end
    end
  end
end
