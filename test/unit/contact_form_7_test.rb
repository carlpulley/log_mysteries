require 'test_helper'

class ContactForm7Test < ActiveSupport::TestCase
  context "contact-form-7.2.1.1.zip" do
    setup do
      @contact_form = "evidence/contact-form-7.2.1.1.zip"
    end
    
    should "be downloaded" do
      assert FileTest.file?(@contact_form)
    end
    
    should "have a valid SHA1" do
      assert_equal "6edbf0506304a1eaf1c03e4a47ad1bcb462e04f2", Digest::SHA1.hexdigest(open(@contact_form, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "Zip archive data", `file #{@contact_form}`
    end
  end
end
