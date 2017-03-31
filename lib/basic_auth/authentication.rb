module BasicAuth
  include Base64

  module Authentication
    def authenticate_or_request_with_http_basic(realm = 'Application')
      authenticate_with_http_basic || request_http_basic_authentication(realm)
    end

    # will authenticate the supplied user:password
    def authenticate_with_http_basic
      if auth_str = request.env['HTTP_AUTHORIZATION']
        return "#{user}:#{password}" == Base64.decode64(auth_str.sub(/^Basic\s+/, ''))
      end
    end

    # sets response headers and will request user agent/browser to supply user:password
    def request_http_basic_authentication(realm = 'Application')
      response.headers["WWW-Authenticate"] = %(Basic realm="#{realm}")
      response.body = "HTTP Basic: Access denied.\n"
      return false
    end

    private
    def user
      ENV["BASIC_AUTH_USER"]
    end

    def password
      ENV["BASIC_AUTH_PASSWORD"]
    end
  end
end