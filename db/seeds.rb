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

# Populate the LogEvent model

Rake::Task["add:tags"].invoke
Rake::Task["add:page:resources"].invoke

# Populate the FileObject model

Rake::Task["db:seed:file_object"].invoke
