namespace :tag do
  namespace :events do
    namespace :wordpress do
      task :plugins => :environment do 
        ApacheAccess.tagged_with("wordpress").url("/wp-content/plugins").all.each do |event|
          event.tag_list << "plugin"
          event.tag_list << "contact-form-7" if event.http[:uri] =~ /contact\-form\-7/
          event.tag_list << "google-syntax-highlighter" if event.http[:uri] =~ /google\-syntax\-highlighter/
          event.tag_list << "google-analyticator" if event.http[:uri] =~ /google\-analyticator/
          event.save!
        end
      end
    end
  end
end
