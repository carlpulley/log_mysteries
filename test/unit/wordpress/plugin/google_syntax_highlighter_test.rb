#    <one line to give the program's name and a brief idea of what it does.>
#    Copyright (C) 2010  Carl J. Pulley
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'test_helper'

class GoogleSyntaxHighlighterContentsTest < ActiveSupport::TestCase
  context "google-syntax-highlighter.1.5.1.zip" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    should "not have any shBrushBash.js entries" do
      ["google-syntax-highlighter/Scripts/shBrushBash.js"].each do |filename|
        assert_equal 0, GoogleSyntaxHighlighter.where(:name => filename).count
      end
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
