namespace :process do
  task :www_media => :environment do
    archive = "evidence/sanitized_log/apache2/www-media.log"
    
    puts `unzip evidence/sanitized_log.zip #{archive}` unless FileTest.file?(archive)
    
    open(archive, "r").each do |line|
      unless ApacheAccess.create(ApacheAccess.parse_log_line(line).merge({ :name => "www-media.log" }))
        puts "Skipping line: #{line}"
      end
    end
  end
end
