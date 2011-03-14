# Download sanitized_log.zip

Rake::Task["download:sanitized_log"].invoke

# Extract the sanitized_log/auth.log data

Rake::Task["extract:auth"].invoke

# Extract the sudo data from the Auth model

Rake::Task["extract:auth:sudo"].invoke

# Tag Sudo commands using debtags

Rake::Task["tag:with:debtags"].invoke

# Extract evidence/sanitized_log/apache2/* data

Rake::Task["extract:www_access"].invoke
Rake::Task["extract:www_media"].invoke

# Download Wordpress Google Syntax Highlighter plugins

Rake::Task["download:google_syntax_highlighter"].invoke
Rake::Task["download:easy_google_syntax_highlighter"].invoke

# Tag events in the ApacheAccess model

Rake::Task["tag:events:wordpress"].invoke
Rake::Task["tag:events:wordpress:version"].invoke
Rake::Task["tag:events:wordpress:plugins"].invoke

# Build ArchiveContent and ApacheAccess relationships

Rake::Task["build:names:url"].invoke
Rake::Task["build:names:url:basename"].invoke

# Build wordpress nad plugin SVN databases

Rake::Task["build:svn:wordpress"].invoke
Rake::Task["build:svn:wp_plugins"].invoke
