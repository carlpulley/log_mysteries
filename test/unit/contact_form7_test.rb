require 'test_helper'

class ContactForm7Test < ActiveSupport::TestCase
  context "contact-form-7.2.1.1.zip" do
    setup do
      @contact_form = "evidence/contact-form-7.2.1.1.zip"
    end
    
    should "be downloaded" do
      assert FileTest.file?(@contact_form)
    end
    
    should "have a valid SHA1" do
      assert_equal "6edbf0506304a1eaf1c03e4a47ad1bcb462e04f2", Digest::SHA1.hexdigest(open(@contact_form, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "Zip archive data", `/usr/bin/file #{@contact_form}`
    end
  
    context "LogEvent model" do
      setup do
        ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
      end
      
      should "be consistent with contact-form-7 tagged entries in LogEvent that exist on the server" do
        ["contact-form-7/styles.css", "contact-form-7/scripts.js"].each do |filename|
          events = LogEvent.tagged_with("contact-form-7").url("/wp-content/plugins/#{filename}").where(:result => 200).get
          assert events.exists?
          events.all.each do |event|
            zip_items = ContactForm7.where(:name => filename)
            assert_equal 1, zip_items.count
            assert_equal zip_items.first.size, event.bytes
          end
        end
      end
    end
  end
end
