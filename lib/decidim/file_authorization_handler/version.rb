# frozen_string_literal: true

module Decidim
  module FileAuthorizationHandler
    DECIDIM_VERSION = "0.29.2"

    # Uses the latest matching Decidim version for
    # - major, minor and patch
    # - the optional extra number is related to this module's patches
    VERSION = "#{DECIDIM_VERSION}.0".freeze
  end
end
