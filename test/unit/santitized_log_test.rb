require 'test_helper'

class SanitizedLogTest < ActiveSupport::TestCase
  context "sanitized_log.zip" do
    setup do
      @sanitized_log = "evidence/sanitized_log.zip"
    end
    
    should "be downloaded" do
      assert FileTest.file?(@sanitized_log)
    end
    
    should "have a valid SHA1" do
      assert_equal "5d317ecf8147cafc0239166e47139afea3200c5b", Digest::SHA1.hexdigest(open(@sanitized_log, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "Zip archive data", `file #{@sanitized_log}`
    end
  end
end
