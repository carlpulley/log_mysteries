require 'test_helper'

class SanitizedLogTest < ActiveSupport::TestCase
  context "www-access.log" do
    setup do
      @www_access = "evidence/sanitized_log/apache2/www-access.log"
    end
    
    should "be extracted" do
      assert FileTest.file?(@www_access)
    end
    
    should "have a valid SHA1" do
      assert_equal "a5e7274843bbf4a617bbdc557425d43b7b4508c2", Digest::SHA1.hexdigest(open(@www_access, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "ASCII text", `file #{@www_access}`
    end
  end
end
