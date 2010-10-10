require 'test_helper'

class WwwMediaTest < ActiveSupport::TestCase
  context "www-media.log" do
    setup do
      @www_media = "evidence/sanitized_log/apache2/www-media.log"
    end
    
    should "be extracted" do
      assert FileTest.file?(@www_media)
    end
    
    should "have a valid SHA1" do
      assert_equal "ee9a42f31d27e388b61c7fc971c78b2895f22142", Digest::SHA1.hexdigest(open(@www_media, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "ASCII text", `/usr/bin/file #{@www_media}`
    end
  end
end
