namespace :db do
  namespace :seed do
    task :www_access => :environment do
      archive = "evidence/sanitized_log/apache2/www-access.log"
      
      puts `unzip evidence/sanitized_log.zip #{archive}` unless FileTest.file?(archive)
      
      open(archive, "r").each do |line|
        unless LogEvent.create(LogEvent.parse_log_line(line).merge({ :name => "www-access.log" }))
          puts "Skipping line: #{line}"
        end
      end
    end
  end
end
