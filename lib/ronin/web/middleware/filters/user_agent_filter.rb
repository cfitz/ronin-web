#
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Web.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

module Ronin
  module Web
    module Middleware
      module Filters
        #
        # A Filter to match requests based on the User Agent header.
        #
        class UserAgentFilter

          #
          # Creates a new User Agent filter.
          #
          # @param [String, Regexp] user_agent
          #   The User Agent pattern to match against.
          #
          # @since 0.3.0
          #
          # @api private
          #
          def initialize(user_agent)
            @user_agent = user_agent
          end

          #
          # Matches the filter against the request.
          #
          # @param [Rack::Request] request
          #   The incoming request.
          #
          # @return [Boolean]
          #   Specifies whether the filter matched the request.
          #
          # @since 0.3.0
          #
          # @api private
          #
          def match?(request)
            if @user_agent.kind_of?(Regexp)
              !((request.user_agent =~ @user_agent).nil?)
            else
              request.user_agent.include?(@user_agent)
            end
          end

        end
      end
    end
  end
end
