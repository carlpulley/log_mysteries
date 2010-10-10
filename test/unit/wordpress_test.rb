require 'test_helper'

class WordpressTest < ActiveSupport::TestCase
  context "wordpress-2.9.2.tar.gz" do
    setup do
      @wordpress = "evidence/wordpress-2.9.2.tar.gz"
    end
    
    should "be downloaded" do
      assert FileTest.file?(@wordpress)
    end
    
    should "have a valid MD5" do
      assert_equal "6023fe6701476c8152bda5d4c6277c69", Digest::MD5.hexdigest(open(@wordpress, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "gzip compressed data", `/usr/bin/file #{@wordpress}`
    end
    
    context "LogEvent model" do
      setup do
        ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
      end
      
      should "be consistent with wordpress tagged entries in LogEvent that exist on the server" do
        ["/wp-includes/js/jquery/jquery.form.js", "/wp-includes/js/jquery/jquery.js"].each do |filename|
          events = LogEvent.tagged_with("wordpress").url(filename).where(:result => 200).get
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
end
