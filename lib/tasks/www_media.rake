namespace :db do
  namespace :seed do
    task :www_media => :environment do
      open("evidence/sanitized_log/apache2/www-media.log", "r").each do |line|
        unless LogEvent.create(LogEvent.parse_log_line(line).merge({ :name => "www-media.log" }))
          puts "Skipping line: #{line}"
        end
      end
    end
  end
end
