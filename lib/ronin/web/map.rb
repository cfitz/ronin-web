require 'ronin/web/spider'

require 'set'
require 'chars'

module Ronin
  module Web
    class Map

      attr_reader :links

      attr_reader :routes

      attr_reader :query_params

      attr_reader :servers

      attr_reader :headers

      attr_reader :custom_headers

      def initialize(options={})
        @links = Hash.new { |hash,key| hash[key] = Set[] }
        @routes = Set[]
        @query_params = Hash.new { |hash,key| hash[key] = Set[] }

        @servers = Set[]
        @headers = Set[]
        @custom_headers = Hash.new { |hash,key| hash[key] = Set[] }
      end

      def map(host)
        @links.clear
        @routes.clear
        @query_params.clear

        @servers.clear
        @headers.clear
        @custom_headers.clear

        Spider.host(host) do |spider|
          spider.every_link do |src,dest|
            @links[src] << dest
          end

          spider.every_page do |page|
            page.url.query_params.each do |name,value|
              @query_params[name] << format_of(value)
            end

            if page.url.path =~ /[0-9]/
              @routes << parse_route(page.url.path)
            end

            if page.headers.has_key?('server')
              @servers << page.headers['server']
            end

            page.headers.each do |name,value|
              if name.start_with?('x-')
                @custom_headers[name] << value
              else
                @headers << name
              end
            end
          end
        end
      end

      protected

      def format_of(value)
        if Chars::NUMERIC === value
          :numeric
        elsif Chars::HEXADECIMAL === value
          case value.length
          when 32
            :md5
          when 40
            :sha1
          when 64
            :sha2
          when 128
            :sha5
          else
            :hexadecimal
          end
        else
          :text
        end
      end

      def parse_route(path)
        parts = path.sub(/\.[a-z]+$/,'').split('/')
        parts.reject! { |part| part.empty? }

        parts.map! do |part,index|
          if part =~ /^[a-z_]$/
            part
          else
            format_of(part)
          end
        end

        return parts
      end

    end
  end
end
