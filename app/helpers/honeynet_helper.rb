module HoneynetHelper
  def pr_S(b, option)
    raise "Error: need a hash argument" unless option.class == Hash
    raise "Error: need a :given key in hash argument to evaluate conditional probabilities" unless option.has_key? :given
    i = option[:given]
    raise "Error: need at least one artefact with a parent entry named #{i}"
    Artefact.joins(:entry).where({:size => b} & {:entry => {:name => i}}).count.to_f/Artefact.joins(:entry).where({:entry => {:name => i}}).count
  end
  
  def pr_T(i, option)
    raise "Error: need to specify a :given hash key/value pair" if option.empty?
    raise "Error: need a hash argument" unless option.class == Hash
    raise "Error: need a :given key in hash argument to evaluate conditional probabilities" unless option.has_key? :given
    b = option[:given]
    raise "Error: need at least one artefact to have size #{b} bytes" if Artefact.where(:size => b).empty?
    if b.class == Fixnum
      Artefact.joins(:entry).where({:entry => {:name => i}} & {:size => b}).count.to_f/Artefact.where(:size => b).count
    elsif b.class == Array
      raise "Error: list should not be empty" if b.empty?
      raise "Error: need a :classes key in hash argument" unless option.has_key? :classes
      if b.count == 1
        pr_T(i, :given => b.first)
      else
        ts = option[:classes]
        (pr_T(i, :given => b[1..-1], :classes => ts) * pr_S(b.first, :given => i))/ts.inject(0) { |s,j| s + pr_T(j, :given => b[1..-1], :classes => ts) * pr_S(b.first, :given => j) }
      end
    end
  end
end
