# Process sanitized_log.zip

Rake::Task["process:sanitized_log"].invoke

# Process evidence/sanitized_log/apache2/* data

Rake::Task["process:www_access"].invoke
Rake::Task["process:www_media"].invoke
Rake::Task["process:www_error"].invoke

# Process Wordpress and Plugin data

Rake::Task["process:wordpress"].invoke
Rake::Task["process:contact_form_7"].invoke
Rake::Task["process:google_analyticator"].invoke
Rake::Task["process:google_syntax_highlighter"].invoke
Rake::Task["process:easy_google_syntax_highlighter"].invoke

# Process the sanitized_log/auth.log data

Rake::Task["process:auth"].invoke

# Extract and process the sudo data from the Auth model

Rake::Task["process:auth:sudo"].invoke

# Tag events in the ApacheAccess model

Rake::Task["tag:events:wordpress"].invoke
Rake::Task["tag:events:wordpress:version"].invoke
Rake::Task["tag:events:wordpress:plugins"].invoke
Rake::Task["tag:events:bot"].invoke
Rake::Task["tag:events:scan"].invoke
Rake::Task["tag:events:rss"].invoke
Rake::Task["tag:files:static"].invoke
Rake::Task["tag:files:dynamic"].invoke

# Build referrer hierarchy for the ApacheAccess model

#Rake::Task["build:hierarchy:referrer"].invoke

# Carve IP Addresses

Rake::Task["add:ip_addresses"].invoke

# Populate the FileObject model

Rake::Task["build:file_objects"].invoke

# Build ArchiveContent and ApacheAccess relationships

Rake::Task["add:names:url"].invoke
Rake::Task["add:names:url:basename"].invoke
