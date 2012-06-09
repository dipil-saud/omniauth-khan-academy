require "multi_json"
require "omniauth"
require "oauth"

module OmniAuth
  module Strategies

    class KhanAcademy
      include OmniAuth::Strategy

      args [:consumer_key, :consumer_secret]

      option :consumer_key, nil
      option :consumer_secret, nil
      option :callback_url, nil
      option :client_options, {}

      DEFAULT_CLIENT_OPTIONS = {
        http_method: :get,
        site: "http://www.khanacademy.org",
        request_token_path: "/api/auth/request_token",
        access_token_path: "/api/auth/access_token"
      }

      attr_reader :access_token

      # this will redirect to the KhanAcademy login page where you can login using google, facebook or khan"s login
      # Khan returns the required credentials for the request token after authentication
      def request_phase
        session["oauth"] ||= {}
        redirect login_url
      end


      def callback_phase
        raise OmniAuth::NoSessionError.new("Session Expired") if session["oauth"].nil?
        # Create a request token from the token and secret provided in the response
        request_token = ::OAuth::AccessToken.new(consumer, request["oauth_token"], request["oauth_token_secret"])
        # Request access_token from the created request_token
        @access_token = consumer.get_access_token(request_token, {oauth_callback: callback_url, oauth_verifier: request["oauth_verifier"]})

        super
      rescue ::Timeout::Error => e
        fail!(:timeout, e)
      rescue ::Net::HTTPFatalError, ::OpenSSL::SSL::SSLError => e
        fail!(:service_unavailable, e)
      rescue ::OAuth::Unauthorized => e
        fail!(:invalid_credentials, e)
      rescue ::MultiJson::DecodeError => e
        fail!(:invalid_response, e)
      rescue ::OmniAuth::NoSessionError => e
        fail!(:session_expired, e)
      end

      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get("/api/v1/user").body)
      end

      uid do
        raw_info["user_id"]
      end

      credentials do
        {"token" => access_token.token, "secret" => access_token.secret}
      end

      extra do
        {"access_token" => access_token, "raw_info" => raw_info}
      end

      info do
        {
          "email" => raw_info["email"],
          "nickname" => raw_info["nickname"]
        }
      end


      def callback_url
        options.callback_url || super
      end


      def consumer
        @consumer ||= ::OAuth::Consumer.new(options.consumer_key, options.consumer_secret, DEFAULT_CLIENT_OPTIONS.merge(options.client_options))
      end


      def login_url
        req = consumer.create_signed_request(:get, consumer.request_token_url, nil, {oauth_callback: callback_url})

        oauth_params_string = req.instance_variable_get("@header")["authorization"].first
        oauth_params_hash = req.parse_header(oauth_params_string)

        "#{consumer.request_token_url}?#{oauth_params_hash.to_query}"
      end

    end

  end
end