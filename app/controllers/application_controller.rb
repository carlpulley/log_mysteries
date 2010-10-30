class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def asn_lookup(ip_address)
    result = `dig +short #{ip_address.split(".").reverse.join(".")}.origin.asn.cymru.com TXT`
    unless result == ""
      result = result.split('|').map { |d| d.strip }
      { :asn => result[0][1..-1].to_i, :bgp_prefix => result[1], :cc => result[2], :registry => result[3], :allocated_at => DateTime.strptime(result[4][0..-2], "%Y-%m-%d") }
    end
  end
end
