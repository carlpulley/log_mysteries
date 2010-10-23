# Download http://honeynet.org/files/sanitized_log.zip

puts `curl http://honeynet.org/files/sanitized_log.zip -o evidence/sanitized_log.zip` unless FileTest.file?("evidence/sanitized_log.zip")

# Extract www-access.log

puts `unzip -d evidence evidence/sanitized_log.zip sanitized_log/apache2/www-access.log` unless FileTest.file?("evidence/sanitized_log/apache2/www-access.log")
puts `unzip -d evidence evidence/sanitized_log.zip sanitized_log/apache2/www-media.log` unless FileTest.file?("evidence/sanitized_log/apache2/www-media.log")
puts `unzip -d evidence evidence/sanitized_log.zip sanitized_log/auth.log` unless FileTest.file?("evidence/sanitized_log/auth.log")

# Download http://wordpress.org/wordpress-2.9.2.tar.gz

puts `curl http://wordpress.org/wordpress-2.9.2.tar.gz -o evidence/wordpress-2.9.2.tar.gz` unless FileTest.file?("evidence/wordpress-2.9.2.tar.gz")

# Download http://downloads.wordpress.org/plugin/contact-form-7.2.1.1.zip

puts `curl http://downloads.wordpress.org/plugin/contact-form-7.2.1.1.zip -o evidence/contact-form-7.2.1.1.zip` unless FileTest.file?("evidence/contact-form-7.2.1.1.zip")

# Download http://downloads.wordpress.org/plugin/google-analyticator.6.0.2.zip

puts `curl http://downloads.wordpress.org/plugin/google-analyticator.6.0.2.zip -o evidence/google-analyticator.6.0.2.zip` unless FileTest.file?("evidence/google-analyticator.6.0.2.zip")

# Download http://downloads.wordpress.org/plugin/google-syntax-highlighter.1.5.1.zip

puts `curl http://downloads.wordpress.org/plugin/google-syntax-highlighter.1.5.1.zip -o evidence/google-syntax-highlighter.1.5.1.zip` unless FileTest.file?("evidence/google-syntax-highlighter.1.5.1.zip")

# Download http://downloads.wordpress.org/plugin/easy-google-syntax-highlighter.zip

puts `curl http://downloads.wordpress.org/plugin/easy-google-syntax-highlighter.zip -o evidence/easy-google-syntax-highlighter.zip` unless FileTest.file?("evidence/easy-google-syntax-highlighter.zip")

# Populate the LogEvent model

Rake::Task["db:seed:www_access"].invoke
Rake::Task["db:seed:www_media"].invoke
Rake::Task["add:tags"].invoke
Rake::Task["add:page:resources"].invoke

# Populate the ArchiveContent models

Rake::Task["db:seed:wordpress"].invoke
Rake::Task["db:seed:contact_form_7"].invoke
Rake::Task["db:seed:google_syntax_highlighter"].invoke
Rake::Task["db:seed:easy_google_syntax_highlighter"].invoke
Rake::Task["db:seed:google_analyticator"].invoke

# Populate the FileObject model

Rake::Task["db:seed:file_object"].invoke

# Populate the Auth model

Rake::Task["db:seed:auth"].invoke
