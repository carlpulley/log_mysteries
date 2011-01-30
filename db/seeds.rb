# Download sanitized_log.zip

Rake::Task["download:sanitized_log"].invoke

# Extract the sanitized_log/auth.log data

Rake::Task["extract:auth"].invoke

# Extract the sudo data from the Auth model

Rake::Task["extract:auth:sudo"].invoke

# Tag Sudo commands using debtags

Rake::Task["tag:with:debtags"].invoke
