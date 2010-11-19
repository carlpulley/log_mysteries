class IpAddress < ActiveRecord::Base
  @@hash = "sha1"
  
  has_many :blacklists
  has_many :apache_accesses
  has_many :apache_errors
  
  def before_create
    asn_lookup
    blacklist_lookup
  end
  
  validates_presence_of :value
  validates_format_of :value, :with => /^\d+\.\d+\.\d+\.\d+$/
  
  private
  
  def asn_lookup
    result = `dig +short #{self.value.split(".").reverse.join(".")}.origin.asn.cymru.com TXT`
    unless result == ""
      result = result.split('|').map { |d| d.strip }
      self.asn = result[0][1..-1].to_i
      self.bgp_prefix = result[1]
      self.cc = result[2]
      self.registry = result[3]
      self.allocated_at = DateTime.strptime(result[4][0..-2], "%Y-%m-%d")
    end
  end
  
  def blacklist_lookup
    uri = URI.parse("http://whatismyipaddress.com/blacklist-check")
    url = "POST #{uri.to_s}?LOOKUPADDRESS=#{self.value}"
    page = add_resource_tagging(uri, Net::HTTP.post_form(uri, {:LOOKUPADDRESS => self.value}).body)
    webpage = WebPage.find_or_create_by_url(url, :page => page.to_s)
    legend = { @@hash => { "eb10c44992742f4653be081db009f453b7c5b646" => "Not Listed", "af1c759f45faee863d9169e20400f0f0a25a3630" => "Listed", "3ebd550fd9ec72bd02601ce2acbb3e408f8fa020" => "Timeout Error", "6c9e96b886b2185fd3a1565cfe5aae3981ec4afb" => "Offline" },
      :ssdeep => { "6:6v/lhPfgl0znDspU9oUyJNf6WRaLERS8ISzFLtVlkLFhaqYBpZajp:6v/7oLo/yXtQYNlkjaZBM" => "Not Listed", "6:6v/lhPfgl0znDsptftJnKSNKyzjB/k2FQWhKvid09kzbanH/NKTNcpP/+p:6v/7oLrtJNP+ud09kzESNj" => "Listed", "6:6v/lhPfgl0znDsptBlc4DETjB/QhDgqwZjLvoqXkaR/O93oKFscGzd0T0GGYnf/N:6v/7oLlMTjyhDwZjLtR/OSKWLaXnf1" => "Timeout Error", "6:6v/lhPfgl0znDsptyO039SoNZIWAX6b2BB/gJ/aRVJFFKttSKo+3/dXsGjP+V1Jh:6v/7oLpYSxfXM2B6VaRVJFFKEp+vSdh" => "Offline" }
    }
    results = page.css("td").select { |item| item.try(:at_css, 'a') && item.try(:at_css, 'img') }.map { |item| puts "#{item}" if item.at_css("a").nil?; [item.at_css("a").text, item.at_css("a")['href'], legend[@@hash][item.at_css("img")[@@hash]]] }
    results.each do |site, ref, status|
      self.blacklists << Blacklist.find_or_create_by_site(site, :status => status, :web_page => webpage, :reference => ref)
    end
  end
  
  def add_resource_tagging(uri, html)
    # TODO: need to handle inline CSS import statements, etc.
    page = Nokogiri::HTML(html)
    rsrc_cache = {}
    rsrc_map = { :img => :src, :link => :href, :script => :src, :object => :data }
    rsrc_map.each_pair do |elem, attrib|
      page.xpath("//#{elem}").each do |rsrc|
        unless rsrc[attrib].nil?
          begin
            file_contents = open("#{uri.scheme}://#{uri.host}#{rsrc[attrib]}").read
            rsrc_cache[rsrc[attrib]] ||= eval "Digest::#{@@hash.upcase}.hexdigest(file_contents)"
            # TODO: need to get ssdeep gem building under ruby 1.9.2!
            #if rsrc_cache[rsrc[attrib]].nil?
            #  fuzzy_hash = nil
            #  Ssdeep.fuzzy_hash_buf(file_contents, file_contents.size, fuzzy_hash)
            #  rsrc_cache[rsrc[attrib]] = fuzzy_hash
            #end
            rsrc[@@hash] = rsrc_cache[rsrc[attrib]]
            #rsrc[:ssdeep] = rsrc_cache[rsrc[attrib]]
          rescue OpenURI::HTTPError
            $stderr.print "Failed to download the page resource: #{rsrc}\n"
            next
          end
        end
      end   
    end
    page
  end
  
end
