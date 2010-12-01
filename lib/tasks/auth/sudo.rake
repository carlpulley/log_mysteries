namespace :process do
  namespace :auth do
    task :sudo => :environment do
      Auth.where(:process => "sudo").all.each do |event|
        message = Sudo.parse_message(event.message)
        puts "Failed to parse message: #{event.message}" if message.nil?
        unless message.nil?
          event.message = message
          event.type = "Sudo"
          unless event.save
            puts "Skipping message: #{event.message}"
          end
        end
      end
    end
  end
end
