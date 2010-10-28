require 'test_helper'

class GoogleAnalyticatorTest < ActiveSupport::TestCase
  context "google-analyticator.6.0.2.zip" do
    setup do
      @auth = "evidence/google-analyticator.6.0.2.zip"
    end
    
    should "be extracted" do
      assert FileTest.file?(@auth)
    end
    
    should "have a valid SHA1" do
      assert_equal "67858ac2861e0be9332cee73240a8f8f814ece0c", Digest::SHA1.hexdigest(open(@auth, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "Zip archive data", `file #{@auth}`
    end
  end
end
