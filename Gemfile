source 'https://rubygems.org'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'

# Component requirements
gem 'haml'
gem 'mongoid'

# Test requirements
gem 'rspec', :group => 'test'
gem 'rack-test', :require => 'rack/test', :group => 'test'

# Padrino Stable Gem
gem 'padrino', '0.12.4'
gem 'bunny'
gem 'nokogiri-happymapper', :require => 'happymapper'
gem 'forkr', '0.1.7'
gem 'ruby-progressbar'

# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core support gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.12.4'
# end
group :production do
    gem 'unicorn'
    gem 'bluepill', '0.1.2'
end

group :development do
  gem 'capistrano'
#  gem 'capistrano-scm-gitcopy'
  gem 'capistrano-bundler'
end

gem 'padrino-flash'
gem 'ruby-progressbar'
