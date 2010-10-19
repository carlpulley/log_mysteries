namespace :db do
  namespace :seed do
    task :easy_google_syntax_highlighter => :environment do
      archive = "evidence/easy-google-syntax-highlighter.zip"
      `unzip -l #{archive}`.split("\n").map do |d| 
        EasyGoogleSyntaxHighlighter.create!({ :archive => archive, :name => $3, :observed_at => DateTime.strptime($2, "%Y-%m-%d %H:%M"), :size => $1.to_i, :directory => ($4 == '/') }) if d =~ /^\s*(\d+)\s+([\d\-]+\s+[\d:]+)\s+(easy\-google\-syntax\-highlighter.*?)(\/?)$/
      end
    end
  end
end
