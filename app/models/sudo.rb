class Sudo < Auth
  serialize :message, Hash
  
  scope :command, lambda { |cmd| where(["message like ?", "%\n:command: %#{cmd}%"]) }
  
  # sudo: pam_unix(sudo:session): session opened for user root by user1(uid=0)
  # sudo:   user1 : TTY=pts/0 ; PWD=/opt/software/web/app ; USER=root ; COMMAND=/usr/bin/svn commit profile/ -m Customer fixtures dont have an owner now more.
  # sudo:   user1 : TTY=pts/0 ; PWD=/opt/software/web/app ; USER=root ; COMMAND=/etc/init.d/apache2 start
  def self.parse_message(message)
    { :username => $1, :tty => $2, :pwd => $3, :user => $4, :command => $5 } if message =~ /^\s*([\w\d]+)\s*:\s*TTY=([^;]+?)\s*;\s*PWD=([^;]+?)\s*;\s*USER=([^;]+?)\s*;\s*COMMAND=(.*)$/
  end
  
  def self.apache_timeline
    (Sudo.command("apache").command("start").all + Sudo.command("apache").command("stop").all).sort { |a, b| a.observed_at.to_i <=> b.observed_at.to_i }.inject([])  do |hs, d| 
      if hs.empty?
        [ { :start => d } ]
      elsif d.message[:command] =~ /stop/ and hs.last.keys.member? :start and not hs.last.keys.member? :stop
        hs[0..-1] + [ hs.last.merge({ :stop => d }) ]
      elsif d.message[:command] =~ /stop/ and not hs.last.keys.member? :start
        hs + [ { :stop => d } ]
      else
        hs + [ { :start => d } ]
      end
    end.map { |d| { :begin => d[:start].try(:observed_at).try(:to_i), :end => d[:stop].try(:observed_at).try(:to_i) } }
  end
end