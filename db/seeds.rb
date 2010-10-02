# Download http://honeynet.org/files/sanitized_log.zip

puts `/usr/bin/curl http://honeynet.org/files/sanitized_log.zip -o evidence/sanitized_log.zip`

# Extract www-access.log

puts `/usr/bin/unzip -d evidence evidence/sanitized_log.zip sanitized_log/apache2/www-access.log`

# Populate the LogEvent model

open("evidence/sanitized_log/apache2/www-access.log", "r").each do |line|
  unless LogEvent.create(LogEvent.parse_log_line(line))
    puts "Skipping line: #{line}"
  end
end
