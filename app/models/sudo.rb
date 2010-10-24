class Sudo < Auth
  serialize :message, Hash
  
  scope :command, lambda { |cmd| where(["message like ?", "%\n:command: %#{cmd}%"]) }
  
  # sudo: pam_unix(sudo:session): session opened for user root by user1(uid=0)
  # sudo:   user1 : TTY=pts/0 ; PWD=/opt/software/web/app ; USER=root ; COMMAND=/usr/bin/svn commit profile/ -m Customer fixtures dont have an owner now more.
  # sudo:   user1 : TTY=pts/0 ; PWD=/opt/software/web/app ; USER=root ; COMMAND=/etc/init.d/apache2 start
  def self.parse_message(message)
    { :username => $1, :tty => $2, :pwd => $3, :user => $4, :command => $5 } if message =~ /^\s*([\w\d]+)\s*:\s*TTY=([^;]+?)\s*;\s*PWD=([^;]+?)\s*;\s*USER=([^;]+?)\s*;\s*COMMAND=(.*)$/
  end
  
  def self.apache_timeline_starts
    Sudo.command("apache2").command("start").where("observed_at >= '2010-04-17'").all.sort { |a, b| a.observed_at.to_i <=> b.observed_at.to_i }.map { |d| { :begin => d.observed_at.to_i, :end => d.observed_at.to_i } }
  end
  
  def self.apache_timeline_ends
    (Sudo.command("apache2").command("stop").where("observed_at >= '2010-04-17'").all + Sudo.command("apache2").command("killall").where("observed_at >= '2010-04-17'").all).sort { |a, b| a.observed_at.to_i <=> b.observed_at.to_i }.map { |d| { :begin => d.observed_at.to_i, :end => d.observed_at.to_i } }
  end
end