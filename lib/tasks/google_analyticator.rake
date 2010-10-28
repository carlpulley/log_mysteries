namespace :db do
  namespace :seed do
    task :google_analyticator => :environment do
      archive = "evidence/google-analyticator.6.0.2.zip"
      
      puts `curl http://downloads.wordpress.org/plugin/google-analyticator.6.0.2.zip -o #{archive}` unless FileTest.file?(archive)
      
      `unzip -l #{archive}`.split("\n").map do |d| 
        GoogleAnalyticator.create!({ :archive => archive, :name => $3, :observed_at => DateTime.strptime($2, "%m-%d-%y %H:%M"), :size => $1.to_i, :directory => ($4 == '/') }) if d =~ /^\s*(\d+)\s+([\d\-]+\s+[\d:]+)\s+(google\-analyticator.*?)(\/?)$/
      end
    end
  end
end
