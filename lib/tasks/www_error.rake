namespace :process do
  task :www_error => :environment do
    archive = "evidence/sanitized_log/auth.log"
    
    puts `unzip evidence/sanitized_log.zip #{archive}` unless FileTest.file?(archive)
    
    open(archive, "r").each do |line|
      unless ApacheError.create(ApacheError.parse_log_line(line))
        puts "Skipping line: #{line}"
      end
    end
  end
end
