source 'http://rubygems.org'

gem 'rails'
gem 'sqlite3-ruby', :require => 'sqlite3'

# To use debugger
gem 'ruby-debug19', :require => 'ruby-debug'

# To use JQuery rather than Prototype
# gem 'jquery-rails'

# Following gems are used for screen scraping
gem 'nokogiri'
# We only want to use the following gem if the web site demands some form of full scale web browser to perform screen scraping!
# NOTE: following gem also requires Firefox to be installed and configured with the jssh plugin (see http://wiki.openqa.org/display/WTR/FireWatir+Installation)
# gem 'firewatir'

# Following gems help with testing
gem "shoulda"
gem "rspec-rails"

# Following gem allows data to be tagged
gem 'acts-as-taggable-on'

# Following gem provides state machine modeling
gem "transitions", :require => ["transitions", "active_record/transitions"]

# Following gem allows hierarchical data to be defined
gem 'nested_set'

# Add in SSDeep bindings for fuzzy hashing
# NOTES:
#  bundle config build.ssdeep --with-ssdeep-include=/usr/local/include/ --with-ssdeep-lib=/usr/local/lib/
#  Need to manually patch ruby-ssdeep.c to deal with ruby 1.9.2
# TODO: need to work out how to get this gem to build under ruby 1.9.2!
#gem 'ssdeep'

# Following gem allows access to the R statistical framework
# NOTES:
#  bundle config build.rsruby --with-R-dir=/usr/lib/R/ --with-R-include=/usr/include/R/
#  also need to ensure environment variable R_HOME = /usr/lib/R/
#gem 'rsruby'