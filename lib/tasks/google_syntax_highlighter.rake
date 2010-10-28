namespace :process do
  task :google_syntax_highlighter => :environment do
    archive = "evidence/google-syntax-highlighter.1.5.1.zip"
    
    puts `curl http://downloads.wordpress.org/plugin/google-syntax-highlighter.1.5.1.zip -o #{archive}` unless FileTest.file?(archive)
    
    `unzip -l #{archive}`.split("\n").map do |d| 
      GoogleSyntaxHighlighter.create!({ :archive => archive, :name => $3, :observed_at => DateTime.strptime($2, "%m-%d-%y %H:%M"), :size => $1.to_i, :directory => ($4 == '/') }) if d =~ /^\s*(\d+)\s+([\d\-]+\s+[\d:]+)\s+(google\-syntax\-highlighter.*?)(\/?)$/
    end
  end
end
