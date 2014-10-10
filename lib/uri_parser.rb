require 'uri_parser/version'
require 'uri_parser/uri_parser'
require 'cgi'

class URIParser
  alias normalized uri

  def path_and_query
    @path_and_query ||= if query.empty?
      path
    else
      "#{path}?#{query}"
    end
  end

  def query_params
    @query_params ||= begin
      k_v_pairs = query.split('&')

      {}.tap do |hash|
        k_v_pairs.each do |kv|
          key, value = kv.split('=')
          hash[CGI.unescape(key)] = value && CGI.unescape(value)
        end
      end
    end
  end
end
