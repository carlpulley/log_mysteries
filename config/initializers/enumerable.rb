module Enumerable
  def collect_with_index(i=0)
    collect{|elm| yield(elm, i+=1)}
  end
  alias map_with_index collect_with_index
end
