# frozen_string_literal: true

source "https://rubygems.org"

# Declare your gem's dependencies in decidim-file_authorization_handler.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

group :development, :test do
  gem "bootsnap", require: false
  gem "decidim", "~> 0.29.0", require: true
  gem "letter_opener_web"
  gem "listen"
  gem "mdl"
end

group :development do
  gem "rubocop", "~> 1.65.0"
end
