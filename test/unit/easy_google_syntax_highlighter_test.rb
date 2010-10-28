require 'test_helper'

class EasyGoogleSyntaxHighlighterTest < ActiveSupport::TestCase
  context "easy-google-syntax-highlighter.zip" do
    setup do
      @auth = "evidence/easy-google-syntax-highlighter.zip"
    end
    
    should "be extracted" do
      assert FileTest.file?(@auth)
    end
    
    should "have a valid SHA1" do
      assert_equal "c854935a85eda6da91d647c654ffd3cc4f2ea53e", Digest::SHA1.hexdigest(open(@auth, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "Zip archive data", `file #{@auth}`
    end
  end
end
