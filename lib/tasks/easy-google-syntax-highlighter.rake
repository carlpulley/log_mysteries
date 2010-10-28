namespace :process do
  task :easy_google_syntax_highlighter => :environment do
    archive = "evidence/easy-google-syntax-highlighter.zip"
    
    puts `curl http://downloads.wordpress.org/plugin/easy-google-syntax-highlighter.zip -o #{archive}` unless FileTest.file?(archive)
    
    `unzip -l #{archive}`.split("\n").map do |d| 
      EasyGoogleSyntaxHighlighter.create!({ :archive => archive, :name => $3, :observed_at => DateTime.strptime($2, "%m-%d-%y %H:%M"), :size => $1.to_i, :directory => ($4 == '/') }) if d =~ /^\s*(\d+)\s+([\d\-]+\s+[\d:]+)\s+(easy\-google\-syntax\-highlighter.*?)(\/?)$/
    end
  end
end
