namespace :db do
  namespace :seed do
    task :contact_form_7 => :environment do
      archive = "evidence/contact-form-7.2.1.1.zip"
      `unzip -l #{archive}`.split("\n").map do |d| 
        ContactForm7.create!({ :archive => archive, :name => $3, :observed_at => DateTime.strptime($2, "%m-%d-%y %H:%M"), :size => $1.to_i, :directory => ($4 == '/') }) if d =~ /^\s*(\d+)\s+([\d\-]+\s+[\d:]+)\s+(contact\-form\-7.*?)(\/?)$/
      end
    end
  end
end
