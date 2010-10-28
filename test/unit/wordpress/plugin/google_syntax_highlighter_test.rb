require 'test_helper'

class GoogleSyntaxHighlighterContentsTest < ActiveSupport::TestCase
  context "google-syntax-highlighter.1.5.1.zip" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    should "be consistent with google-syntax-highlighter tagged entries in ApacheAccess that exist on the server" do
      ["google-syntax-highlighter/Styles/SyntaxHighlighter.css", "google-syntax-highlighter/Scripts/shBrushPhp.js", "google-syntax-highlighter/Scripts/shBrushCSharp.js", "google-syntax-highlighter/Scripts/shBrushJScript.js", "google-syntax-highlighter/Scripts/shBrushSql.js", "google-syntax-highlighter/Scripts/shBrushJava.js", "google-syntax-highlighter/Scripts/shCore.js", "google-syntax-highlighter/Scripts/shBrushXml.js", "google-syntax-highlighter/Scripts/shBrushVb.js", "google-syntax-highlighter/Scripts/shBrushPython.js", "google-syntax-highlighter/Scripts/shBrushRuby.js", "google-syntax-highlighter/Scripts/shBrushCpp.js", "google-syntax-highlighter/Scripts/shBrushDelphi.js", "google-syntax-highlighter/Scripts/shBrushCss.js"].each do |filename|
        events = ApacheAccess.tagged_with("google-syntax-highlighter").url("/wp-content/plugins/#{filename}").where(:result => 200).get
        assert events.exists?
        events.all.each do |event|
          zip_items = GoogleSyntaxHighlighter.where(:name => filename)
          assert_equal 1, zip_items.count
          assert_equal zip_items.first.size, event.bytes
        end
      end
    end
  end
end
