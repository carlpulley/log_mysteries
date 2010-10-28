require 'test_helper'

class GoogleSyntaxHighlighterTest < ActiveSupport::TestCase
  context "google-syntax-highlighter.1.5.1.zip" do
    setup do
      @auth = "evidence/google-syntax-highlighter.1.5.1.zip"
    end
    
    should "be extracted" do
      assert FileTest.file?(@auth)
    end
    
    should "have a valid SHA1" do
      assert_equal "4ee1abd94be63a0a3154dbd517fc2b6235331039", Digest::SHA1.hexdigest(open(@auth, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "Zip archive data", `file #{@auth}`
    end
  end
end
