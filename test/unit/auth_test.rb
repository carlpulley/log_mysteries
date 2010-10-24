require 'test_helper'

class AuthTest < ActiveSupport::TestCase
  context "auth.log" do
    setup do
      @auth = "evidence/sanitized_log/auth.log"
    end
    
    should "be extracted" do
      assert FileTest.file?(@auth)
    end
    
    should "have a valid SHA1" do
      assert_equal "f5af0048ac672c3a993be6a5a6c4af243b604dfa", Digest::SHA1.hexdigest(open(@auth, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "ASCII text", `/usr/bin/file #{@auth}`
    end
  end
end
