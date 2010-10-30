namespace :tag do
  namespace :events do
    namespace :wordpress do
      task :version => :environment do 
        ApacheAccess.tagged_with("wordpress").all.each do |event|
          event.tag_list << "version" if event.http[:uri] =~ /\?v(er(sion)?)?=/
          event.save!
        end
      end
    end
  end
end
