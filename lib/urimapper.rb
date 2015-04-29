require "urimapper/version"
require "addressable/uri"

fail "Skeevy #{UriMapper::VERSION} requires Ruby 2.1 or later." if RUBY_VERSION < '2.1.0'

module UriMapper

  RE_WWW   = Regexp.new(/^www\./)
  RE_SLASH = Regexp.new(/(\/)+$/)
  RE_WHITE = Regexp.new(/\s+/)

  class << self
    def parse(where)
      where.freeze
      if where.nil? || where.empty?
        raise_error where
      end
      unless where.include?('.'.freeze)
        raise_error where
      end
      fqdn = where
      if where.slice(0, 2) == '//'.freeze
        fqdn = "http:#{where}"
      elsif where.slice(0, 4) != 'http'.freeze
        fqdn = "http://#{where}"
      end
      uri  = nil
      fqdn = fqdn.strip
      begin
        uri = ::Addressable::URI.parse(fqdn).to_hash
      rescue Exception => e
        raise_error e.message
      end

      path         = uri[:path].sub(RE_SLASH, ''.freeze).strip
      path         = (path.empty?) ? '/'.freeze : path
      query        = uri[:query].to_s.strip
      fragment     = uri[:fragment].to_s.strip
      host         = uri[:host].strip
      domain       = host.gsub(RE_WWW, ''.freeze).gsub(RE_WHITE, ''.freeze).chomp('.'.freeze)
      ssl          = (uri[:scheme] == 'https'.freeze) ? true : false
      port         = uri[:port] || ((ssl) ? 443 : 80)
      logical_port = (ssl) ? ((port == 443) ? ''.freeze : ":#{port}") : ((port == 80) ? ''.freeze : ":#{port}")
      canon        = "#{domain}#{logical_port}#{path}"
      canon        += "?#{query}" unless query.empty?
      canon        += "##{fragment}" unless fragment.empty?
      www          = (host.slice(0, 4)=='www.'.freeze) ? true : false
      {
          domain:       domain,
          www:          www,
          ssl:          ssl,
          path:         path,
          port:         port,
          fragment:     fragment,
          logical_port: logical_port,
          query:        query,
          canonical:    canon,
          raw:          "#{www ? 'www.'.freeze : ''.freeze}#{domain}#{logical_port}",
          hash:         Digest::SHA1.hexdigest(canon)
      }
    end

    def raise_error(where)
      raise ArgumentError, "Invalid URL passed to parser: '#{where}'", []
    end

    def calculate_hash(what)
      Digest::SHA1.hexdigest(what)
    end

    def inspect
      "UriMapper #{UriMapper::VERSION}"
    end
  end

end
