namespace :db do
  namespace :seed do
    task :wordpress => :environment do
      archive = "evidence/wordpress-2.9.2.tar.gz"
      `/bin/tar -ztvf #{archive}`.split("\n").map do |d| 
        Wordpress.create!({ :archive => archive, :name => $4, :observed_at => DateTime.strptime($3, "%Y-%m-%d %b %H:%M"), :size => $2.to_i, :directory => ($1 == 'd') }) if d =~ /^([d\-]).*?www\-data\s+(\d+)\s+(.*?)\s+wordpress(.*)$/
      end
    end
  end
end
