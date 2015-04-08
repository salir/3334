require 'pp' if ENV['DEBUG']
require 'faraday'
require 'github_api/version'
require 'github_api/configuration'
require 'github_api/constants'
require 'github_api/utils/url'
require 'github_api/connection'
require 'github_api/deprecation'
require 'github_api/core_ext/ordered_hash'
require 'github_api/ext/faraday'
require 'github_api/middleware'

#1Agregado en commit 2 diff2 para ser borrada
module Github
  LIBNAME = 'github_api'

  LIBDIR = File.expand_path("../#{LIBNAME}", __FILE__)

 #1Agregado en master commit 1

  class << self
    def included(base)
      base.extend ClassMethods
    end

    # @param [Hash] options
    #   the configuration options
    #
    # @return [Github::Client]
    #
    # @api public
    def new(options = {}, &block)
      Client.new(options, &block)
    end

    # @return [Proc]
    #
    #1Comentario en commit 1 diff2
    #2Comentario en commit 1 diff2
    # @api private
    def default_middleware(options = {})
      Middleware.default(options)
    end

    # Delegate to Github::Client
    #
    # @api private
    def method_missing(method_name, *args, &block)
      if new.respond_to?(method_name)
        new.send(method_name, *args, &block)
      elsif configuration.respond_to?(method_name)
        Github.configuration.send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to?(method_name, include_private = false)
      new.respond_to?(method_name, include_private) ||
      configuration.respond_to?(method_name) ||
      super(method_name, include_private)
    end
  end

  module ClassMethods

    # Requires internal libraries
    #
    # @param [String] prefix
    #   the relative path prefix
    # @param [Array[String]] libs
    #   the array of libraries to require
    #
    # @return [self]
    def require_all(prefix, *libs)
      libs.each do |lib|
        require "#{File.join(prefix, lib)}"
      end
    end

    # The client configuration
    #
    # @return [Configuration]
    #
    # @api public
    def configuration
      @configuration ||= Configuration.new
    end

    #   Github.configure do |c|
    #     c.some_option = true
    #   end
    #
    # @yield the configuration block
    # @yieldparam configuration [Github::Configuration]
    #   the configuration instance
    #
    # @return [nil]
    #
    # @api public
    def configure
      yield configuration
    end
  end
  #3Comentario en commit 1 diff2

  extend ClassMethods

  require_all LIBDIR,
    'authorization',
    'validations',
    'normalizer',
    'parameter_filter',
    'api',
    'client',
    'pagination',
    'request',
    'response',
    'response_wrapper',
    'error',
    'mime_type',
    'page_links',
    'paged_request',
    'page_iterator',
    'params_hash'

end # Github
