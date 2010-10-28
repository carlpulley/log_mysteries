# Process sanitized_log.zip

Rake::Task["db:seed:sanitized_log"].invoke

# Process evidence/sanitized_log/apache2/* data

Rake::Task["db:seed:www_access"].invoke
Rake::Task["db:seed:www_media"].invoke
Rake::Task["db:seed:www_error"].invoke

# Process Wordpress and Plugin data

Rake::Task["db:seed:wordpress"].invoke
Rake::Task["db:seed:contact_form_7"].invoke
Rake::Task["db:seed:google_analyticator"].invoke
Rake::Task["db:seed:google_syntax_highlighter"].invoke
Rake::Task["db:seed:easy_google_syntax_highlighter"].invoke

# Populate the LogEvent model

Rake::Task["add:tags"].invoke
Rake::Task["add:page:resources"].invoke

# Populate the FileObject model

Rake::Task["db:seed:file_object"].invoke

# Process the sanitized_log/auth.log data

Rake::Task["db:seed:auth"].invoke

# Extract and process the sudo data from the Auth model

Rake::Task["db:seed:auth:sudo"].invoke
