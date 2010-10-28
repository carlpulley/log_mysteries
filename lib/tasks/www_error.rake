namespace :db do
  namespace :seed do
    task :www_error => :environment do
      archive = "evidence/sanitized_log/auth.log"
      
      puts `unzip evidence/sanitized_log.zip #{archive}` unless FileTest.file?(archive)
      
      open(archive, "r").each do |line|
        unless LogEvent.create(LogEvent.parse_log_line(line).merge({ :name => "www-error.log" }))
          puts "Skipping line: #{line}"
        end
      end
    end
  end
end
