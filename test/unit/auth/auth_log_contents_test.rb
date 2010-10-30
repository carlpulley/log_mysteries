require 'test_helper'

class AuthLogContentsTest < ActiveSupport::TestCase
  context "Auth model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
      @events = Auth.scoped
    end
    
    should "have contents matching auth.log" do
      archive = "evidence/sanitized_log/auth.log"

      table_contents = []
      @events.find_each do |data|
        table_contents << data.to_s
      end
      table_contents << ""
      assert_equal "d08e509107f3e578ca22fb5c9358e75228ab869c", Digest::SHA1.hexdigest(table_contents.join("\n"))
    end
    
    should "have observed_at timestamps increasing with their position within auth.log" do
      assert SanitizedLog.where(:name => "sanitized_log/auth.log").first.observed_at >= @events.last.observed_at
      last_date = nil
      @events.find_each do |data|
        assert data.observed_at >= last_date unless last_date.nil?
        last_date = data.observed_at
      end
    end
  end
end
