namespace :db do
  namespace :seed do
    task :www_access => :environment do
      open("evidence/sanitized_log/apache2/www-access.log", "r").each do |line|
        unless LogEvent.create(LogEvent.parse_log_line(line).merge({ :name => "www-access.log" }))
          puts "Skipping line: #{line}"
        end
      end
    end
  end
end
