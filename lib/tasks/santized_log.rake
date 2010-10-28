namespace :db do
  namespace :seed do
    task :sanitized_log => :environment do
      archive = "evidence/sanitized_log.zip"
      
      puts `curl http://honeynet.org/files/sanitized_log.zip -o #{archive}` unless FileTest.file?(archive)
      
      `unzip -l #{archive}`.split("\n").map do |d| 
        SanitizedLog.create!({ :archive => archive, :name => $3, :observed_at => DateTime.strptime($2, "%m-%d-%y %H:%M"), :size => $1.to_i, :directory => ($4 == '/') }) if d =~ /^\s*(\d+)\s+([\d\-]+\s+[\d:]+)\s+(sanitized_log.*?)(\/?)$/
      end
    end
  end
end
