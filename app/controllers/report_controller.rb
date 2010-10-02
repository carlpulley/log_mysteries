class ReportController < ApplicationController
  def index
    @log_events = LogEvent.scoped
  end
end
