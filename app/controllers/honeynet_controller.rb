class HoneynetController < ApplicationController
  def index
    @data = ApacheAccess.scoped
  end
end
