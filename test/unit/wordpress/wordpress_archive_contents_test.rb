require 'test_helper'

class WordpressArchiveContentsTest < ActiveSupport::TestCase
  context "ApacheAccess model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    should "be consistent with wordpress tagged entries in ApacheAccess that exist on the server" do
      ["/wp-includes/js/jquery/jquery.form.js", "/wp-includes/js/jquery/jquery.js"].each do |filename|
        events = ApacheAccess.tagged_with("wordpress").url(filename).where(:result => 200).get
        assert events.exists?
        events.all.each do |event|
          zip_items = Wordpress.where(:name => filename)
          assert_equal 1, zip_items.count
          assert_equal zip_items.first.size, event.bytes
        end
      end
    end
  end
end
