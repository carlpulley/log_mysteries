require 'test_helper'

class AccessLogContentsTest < ActiveSupport::TestCase
  context "ApacheAccess model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    should "be consistent with contact-form-7 tagged entries in LogEvent that exist on the server" do
      ["contact-form-7/styles.css", "contact-form-7/scripts.js"].each do |filename|
        events = ApacheAccess.tagged_with("contact-form-7").url("/wp-content/plugins/#{filename}").where(:result => 200).get
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
