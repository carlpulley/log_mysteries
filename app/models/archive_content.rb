class ArchiveContent < ActiveRecord::Base
  def to_s
    "#{observed_at.in_time_zone('Pacific Time (US & Canada)').strftime("%d/%b/%Y %H:%M:%S %z")} #{name} #{size}B"
  end
end
