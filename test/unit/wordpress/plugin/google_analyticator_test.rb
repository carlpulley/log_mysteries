require 'test_helper'

class GoogleAnalyticatorContentsTest < ActiveSupport::TestCase
  context "google-analyticator.6.0.2.zip" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    should "be consistent with google-analyticator tagged entries in ApacheAccess that exist on the server" do
      ["google-analyticator/external-tracking.min.js"].each do |filename|
        events = ApacheAccess.tagged_with("google-analyticator").url("/wp-content/plugins/#{filename}").where(:result => 200).get
        assert events.exists?
        events.all.each do |event|
          zip_items = GoogleAnalyticator.where(:name => filename)
          assert_equal 1, zip_items.count
          assert_equal zip_items.first.size, event.bytes
        end
      end
    end
  end
end
