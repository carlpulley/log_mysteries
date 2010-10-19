namespace :db do
  namespace :seed do
    task :google_syntax_highlighter => :environment do
      archive = "evidence/google-syntax-highlighter.1.5.1.zip"
      `unzip -l #{archive}`.split("\n").map do |d| 
        GoogleSyntaxHighlighter.create!({ :archive => archive, :name => $3, :observed_at => DateTime.strptime($2, "%Y-%m-%d %H:%M"), :size => $1.to_i, :directory => ($4 == '/') }) if d =~ /^\s*(\d+)\s+([\d\-]+\s+[\d:]+)\s+(google\-syntax\-highlighter.*?)(\/?)$/
      end
    end
  end
end
