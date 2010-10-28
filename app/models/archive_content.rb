class ArchiveContent < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  
  def to_s
    "#{observed_at.in_time_zone('Pacific Time (US & Canada)').strftime("%d/%b/%Y %H:%M:%S %z")} #{name} #{number_to_human_size(size)}"
  end
end
