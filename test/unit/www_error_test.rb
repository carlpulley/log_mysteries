require 'test_helper'

class WwwErrorTest < ActiveSupport::TestCase
  context "www-error.log" do
    setup do
      @www_error = "evidence/sanitized_log/apache2/www-error.log"
    end
    
    should "be extracted" do
      assert FileTest.file?(@www_error)
    end
    
    should "have a valid SHA1" do
      assert_equal "ba135fe6ba2d61b3887925ba0461072c17a4edd3", Digest::SHA1.hexdigest(open(@www_error, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "ASCII text", `file #{@www_error}`
    end
  end
end
