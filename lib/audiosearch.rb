# Audiosear.ch Ruby Client
# Copyright 2015 - Pop Up Archive
# Licensed under Apache 2 license - see LICENSE file
#
#

require 'rubygems'
require 'json'
require 'faraday_middleware'
require 'oauth2'
require 'uri'

module Audiosearch

  module Error
    class NotFound < StandardError

    end
  end

  class FaradayErrHandler < Faraday::Response::Middleware
    def on_complete(env)
      # Ignore any non-error response codes
      return if (status = env[:status]) < 400
      #puts "got response status #{status}"
      case status
      when 404
        #raise Error::NotFound
        # 404 errors not fatal
      else
        #puts pp(env)
        super  # let parent class deal with it
      end
    end
  end

  class Client

    attr_accessor :host
    attr_accessor :debug
    attr_accessor :agent
    attr_accessor :user_agent
    attr_accessor :cookies
    attr_accessor :api_endpoint
    attr_accessor :croak_on_404

    def version
      return "1.0.0"
    end

    def initialize(args)
      #puts args.inspect
      @un                  = args[:username]
      @pw                  = args[:password]
      @oauth_id            = args[:id]
      @oauth_secret        = args[:secret]
      @oauth_redir_uri     = args[:redir_uri] || 'urn:ietf:wg:oauth:2.0:oob'
      @host                = args[:host] || 'https://www.audiosear.ch'
      @debug               = args[:debug]
      @user_agent          = args[:user_agent] || 'audiosearch-ruby-client/'+version()
      @api_endpoint        = args[:api_endpoint] || '/api'
      @croak_on_404        = args[:croak_on_404] || false

      # normalize host
      @host.gsub!(/\/$/, '')

      # sanity check
      begin
        uri = URI.parse(@host)
      rescue URI::InvalidURIError => err
        raise "Bad :host value " + err
      end
      if (!uri.host || !uri.port)
        raise "Bad :host value " + @server
      end

      @agent = get_agent()

    end

    def get_oauth_token(options={})
      oauth_options = {
        site:            @host + @api_endpoint,
        authorize_url:   @host + '/oauth/authorize',
        token_url:       @host + '/oauth/token',
        redirect_uri:    @oauth_redir_uri,
        connection_opts: options.merge( { :ssl => {:verify => false}, } )
      }

      # TODO

      client = OAuth2::Client.new(@oauth_id, @oauth_secret, oauth_options) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger if @debug
        faraday.adapter  :excon
      end

      token = nil
      if @un && @pw
        # TODO 3-legged oauth to @authorize_url
      else
        token = client.client_credentials.get_token()
      end

      return token
    end

    def get_agent()
      uri = @host + @api_endpoint
      opts = {
        :url => uri,
        :ssl => {:verify => false},
        :headers => {
          'User-Agent'   => @user_agent,
          'Accept'       => 'application/json',
          'Cookie'       => @cookies
        }
      }
      @token = get_oauth_token
      #puts "token="
      #puts pp(@token)
      conn = Faraday.new(opts) do |faraday|
        faraday.request :url_encoded
        [:mashify, :json].each{|mw| faraday.response(mw) }
        if !@croak_on_404
          faraday.use Audiosearch::FaradayErrHandler
        else 
          faraday.response(:raise_error)
        end
        faraday.request :authorization, 'Bearer', @token.token
        faraday.response :logger if @debug
        faraday.adapter  :excon   # IMPORTANT this is last
      end

      return conn
    end

    def get(path, params={})
      resp = @agent.get @api_endpoint + path, params
      @debug and pp(resp)
      return Audiosearch::Response.new resp
    end

    def get_show(id)
      resp = get('/shows/'+id.to_s)
      return resp.http_resp.body
    end

    def get_episode(ep_id)
      resp = get('/episodes/'+ep_id.to_s)
      return resp.http_resp.body
    end

  end # end Client

  # dependent classes
  class Response

    attr_accessor :http_resp

    def initialize(http_resp)
      @http_resp = http_resp

      #warn http_resp.headers.inspect
      #warn "code=" + http_resp.status.to_s

      @is_ok = false
      if http_resp.status.to_s =~ /^2\d\d/
        @is_ok = true
      end

    end

    def status()
      return @http_resp.status
    end

    def is_success()
      return @is_ok
    end

    def method_missing(meth, *args, &block)
      if @http_resp.body.respond_to? meth
        @http_resp.body.send(meth, *args, &block)
      else
        super
      end
    end

    def respond_to?(meth)
      if @http_resp.body.respond_to? meth
        true
      else
        super
      end
    end

  end # end Response

end # end module
