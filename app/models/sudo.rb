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

class Sudo < Auth
  #include ActiveRecord::Transitions
  
  serialize :message, Hash
  
  scope :command, lambda { |cmd| where(["message like ?", "%\n:command: %#{cmd}%"]) }
  scope :tty, lambda { |tty| where(["message like ?", "%\n:tty: %#{tty}\n%"]) }
  scope :pwd, lambda { |pwd| where(["message like ?", "%\n:pwd: %#{pwd}%"]) }
  
  #state_machine :apache2 do
  #  state :stopped # initial state
  #  state :running
  #
  #  event :start do
  #    transitions :to => :running, :from => [:stopped], :guard => lambda { |d| d.message[:command] =~ /\/etc\/init.d\/apache2 start/ }
  #  end
  #  event :stop do
  #    transitions :to => :stopped, :from => [:running], :guard => lambda { |d| d.message[:command] =~ /\/etc\/init.d\/apache2 stop/ or d.message[:command] =~ /\/usr\/bin\/killall -9 apache2/ }, :on_transition => :pair_with_start_event
  #  end
  #end
  
  # sudo:   user1 : user NOT in sudoers ; TTY=pts/0 ; PWD=/home/user1 ; USER=root ; COMMAND=/bin/su -
  # sudo: pam_unix(sudo:session): session opened for user root by user1(uid=0)
  # sudo: pam_unix(sudo:auth): authentication failure; logname=user1 uid=0 euid=0 tty=/dev/pts/0 ruser= rhost=  user=user1
  # sudo:   user3 : unable to resolve host dev-.domain.org
  # sudo:   user1 : TTY=pts/0 ; PWD=/opt/software/web/app ; USER=root ; COMMAND=/usr/bin/svn commit profile/ -m Customer fixtures dont have an owner now more.
  def self.parse_message(message)
    return { :subject => $1, :error => $2, :tty => $3, :pwd => $4, :user => $5, :command => $6 } if message =~ /^\s*([\w\d]+)\s+:\s+(user NOT in sudoers)\s+;\s+TTY=([^\s]+)\s+;\s+PWD=([^\s]+)\s+;\s+USER=([\w\d]+)\s+;\s+COMMAND=(.*)$/
    return { :token => $1, :state => $2, :for => $3, :by => $5, :uid => $6 } if message =~ /^\s*pam_unix\((.*?)\):\s+session\s+(\w+)\s+for\s+user\s+([\w\d]+)(\s+by\s+([\w\d]*)\(uid=(\d+)\))?$/
    return { :token => $1, :value => $2, :logname => $3, :uid => $4, :euid => $5, :tty => $6, :ruser => $7, :rhost => $8, :user => $9 } if message =~ /^\s*pam_unix\((.*?)\):\s+([^;]+?);\s+logname=([\w\d]+)\s+uid=(\d+)\s+euid=(\d+)\s+tty=([^\s]+)\s+ruser=([\w\d]*)\s+rhost=([\w\d]*)\s+user=([\w\d]+)$/
    return { :subject => $1, :host => $2 } if message =~ /^\s*([\w\d]+)\s*:\s*unable to resolve host (.*)$/
    return { :subject => $1, :tty => $2, :pwd => $3, :user => $4, :command => $5 } if message =~ /^\s*([\w\d]+)\s*:\s*TTY=([^;]+?)\s*;\s*PWD=([^;]+?)\s*;\s*USER=([^;]+?)\s*;\s*COMMAND=(.*)$/
  end
  
  def self.parse_log_line(log_line)
    super log_line do |message|
      parse_message message
    end
  end
  
  def to_s
    super do |message|
      message = YAML::load(message) unless message.class == Hash
      result = "#{message[:subject]} : #{message[:error]} ; TTY=#{message[:tty]} ; PWD=#{message[:pwd]} ; USER=#{message[:user]} ; COMMAND=#{message[:command]}" if message.keys.count == 6
      result = "pam_unix(#{message[:token]}): session #{message[:state]} for user #{message[:for]}#{" by #{message[:by]}(uid=#{message[:uid]})" unless message[:by].nil?}" if message.keys.count == 5 and message.keys.member? :state
      result = "pam_unix(#{message[:token]}): #{message[:value]}; logname=#{message[:logname]} uid=#{message[:uid]} euid=#{message[:euid]} tty=#{message[:tty]} ruser=#{message[:ruser]} rhost=#{message[:rhost]} user=#{message[:user]}" if message.keys.count == 9
      result = "#{message[:subject]} : unable to resolve host #{message[:host]}" if message.keys.count == 2
      result = "#{message[:subject]} : TTY=#{message[:tty]} ; PWD=#{message[:pwd]} ; USER=#{message[:user]} ; COMMAND=#{message[:command]}" if message.keys.count == 5 and not message.keys.member? :state
      result
    end
  end
end