namespace :db do
  namespace :seed do
    task :sudo => :environment do
      Auth.where(:process => "sudo").all.each do |event|
        message = Sudo.parse_message(event[:message])
        event.message = message unless message.nil?
        event.type = "Sudo"
        unless event.save
          puts "Skipping message: #{event[:message]}"
        end
      end
    end
  end
end
