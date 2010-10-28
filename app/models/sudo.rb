class Sudo < Auth
  include ActiveRecord::Transitions
  
  serialize :message, Hash
  
  scope :command, lambda { |cmd| where(["message like ?", "%\n:command: %#{cmd}%"]) }
  
  state_machine :apache2 do
    state :stopped # initial state
    state :running
  
    event :start do
      transitions :to => :running, :from => [:stopped], :guard => lambda { |d| d.message[:command] =~ /\/etc\/init.d\/apache2 start/ }
    end
    event :stop do
      transitions :to => :stopped, :from => [:running], :guard => lambda { |d| d.message[:command] =~ /\/etc\/init.d\/apache2 stop/ or d.message[:command] =~ /\/usr\/bin\/killall -9 apache2/ }, :on_transition => :pair_with_start_event
    end
  end
  
  # sudo:   user1 : user NOT in sudoers ; TTY=pts/0 ; PWD=/home/user1 ; USER=root ; COMMAND=/bin/su -
  # sudo: pam_unix(sudo:session): session opened for user root by user1(uid=0)
  # sudo: pam_unix(sudo:auth): authentication failure; logname=user1 uid=0 euid=0 tty=/dev/pts/0 ruser= rhost=  user=user1
  # sudo:   user3 : unable to resolve host dev-.domain.org
  # sudo:   user1 : TTY=pts/0 ; PWD=/opt/software/web/app ; USER=root ; COMMAND=/usr/bin/svn commit profile/ -m Customer fixtures dont have an owner now more.
  def self.parse_message(message)
    return { :subject => $1, :tty => $2, :pwd => $3, :user => $4, :command => $5 } if message =~ /^([\w\d]+)\s+:\s+user NOT in sudoers\s+;\s+TTY=([^\s]+)\s+;\s+PWD=([^\s]+)\s+;\s+USER=([\w\d]+)\s+;\s+COMMAND=(.*)$/
    return { :token => "sudo:session", :state => $1, :for => $2, :by => $4, :uid => $5 } if message =~ /^\s*pam_unix\(sudo:session\):\s+session\s+(\w+)\s+for\s+user\s+([\w\d]+)(\s+by\s+([\w\d]*)\(uid=(\d+)\))?$/
    return { :token => "sudo:auth", :value => $1, :logname => $2, :uid => $3, :euid => $4, :tty => $5, :ruser => $6, :rhost => $7, :user => $8 } if message =~ /^\s*pam_unix\(sudo:auth\):\s+([^;]+?);\s+logname=([\w\d]+)\s+uid=(\d+)\s+euid=(\d+)\s+tty=([^\s]+)\s+ruser=([\w\d]*)\s+rhost=([\w\d]*)\s+user=([\w\d]+)$/
    return { :subject => $1, :host => $2 } if message =~ /^\s*([\w\d]+)\s*:\s*unable to resolve host (.*)$/
    return { :subject => $1, :tty => $2, :pwd => $3, :user => $4, :command => $5 } if message =~ /^\s*([\w\d]+)\s*:\s*TTY=([^;]+?)\s*;\s*PWD=([^;]+?)\s*;\s*USER=([^;]+?)\s*;\s*COMMAND=(.*)$/
  end
  
  def self.apache_timeline_starts
    Sudo.command("apache2").command("start").all.sort { |a, b| a.observed_at.to_i <=> b.observed_at.to_i }.map { |d| { :begin => d.observed_at.to_i, :end => d.observed_at.to_i } }
  end
  
  def self.apache_timeline_ends
    (Sudo.command("apache2").command("stop").all + Sudo.command("apache2").command("killall").all).sort { |a, b| a.observed_at.to_i <=> b.observed_at.to_i }.map { |d| { :begin => d.observed_at.to_i, :end => d.observed_at.to_i } }
  end
end