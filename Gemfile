source "https://rubygems.org"

ruby "3.2.9"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.3"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Hotwire
gem "hotwire-rails", "~> 0.1"

# UI/CSS
gem "tailwindcss-rails", "~> 2.0"

# Autenticação e Autorização
gem "devise", "~> 4.9"
gem "pundit", "~> 2.3"

# Formulários
gem "simple_form", "~> 5.3"

# Paginação e Busca
gem "kaminari", "~> 1.2"
gem "ransack", "~> 4.0"

# Relatórios e Exportação
gem "prawn", "~> 2.4"
gem "prawn-table", "~> 0.2"
gem "caxlsx", "~> 3.4"
gem "caxlsx_rails", "~> 0.6"

# Gráficos
gem "chartkick", "~> 5.0"
gem "groupdate", "~> 6.4"

# Utilidades
gem "paranoia"  # Soft delete
gem "paper_trail"  # Auditoria

# Cache e Background Jobs
gem "redis", "~> 5.0"
gem "sidekiq", "~> 7.2"

# Segurança
gem "rack-attack"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Testing
  gem "rspec-rails", "~> 6.1"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.2"
  gem "pry-rails", "~> 0.3"
  gem "bullet", "~> 7.1"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Code quality
  gem "rubocop-rails", "~> 2.23", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Code annotation
  gem "annotate", "~> 3.2"

  # Performance profiling
  gem "rack-mini-profiler", "~> 3.3"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 6.0"
  gem "database_cleaner-active_record", "~> 2.1"
  gem "simplecov", "~> 0.22", require: false
end

group :production do
  # Error tracking
  gem "sentry-ruby", "~> 6.0"
  gem "sentry-rails", "~> 6.0"
end
