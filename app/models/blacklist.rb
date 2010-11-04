class Blacklist < ActiveRecord::Base
  belongs_to :ip_address
  belongs_to :web_page
end
