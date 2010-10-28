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
      assert_match "gzip compressed data", `file #{@wordpress}`
    end
  end
end
