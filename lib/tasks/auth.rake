namespace :db do
  namespace :seed do
    task :auth => :environment do
      open("evidence/sanitized_log/auth.log", "r").each do |line|
        unless Auth.create(Auth.parse_log_line(line))
          puts "Skipping line: #{line}"
        end
      end
    end
  end
end
