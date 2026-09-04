source "https://rubygems.org"

# ==========================================
# 1. CORE DO RAILS & PERFORMANCE (Infraestrutura)
# ==========================================
gem "rails", "~> 8.1.3", ">= 8.1.3.1"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false

# Stack Hotwire (Performance SPA sem o peso do Node.js)
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# Solid Suite (Fila, Cache e Websockets direto no Banco)
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# ==========================================
# 2. DESIGN SYSTEM & ARQUITETURA MVC DE UI
# ==========================================
gem "tailwindcss-rails"
gem "view_component", "~> 4.15"
gem "rails_icons", "~> 1.9"

# ==========================================
# 3. SEGURANÇA, GOVERNANÇA E AUDITORIA (Zero Trust)
# ==========================================
gem "devise", "~> 5.0"
gem "pundit", "~> 2.5"
gem "paper_trail", "~> 17.0"

# ==========================================
# 4. UTILITÁRIOS E INTERNACIONALIZAÇÃO
# ==========================================
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "image_processing", "~> 1.2"
gem "rails-i18n", "~> 8.1"
gem "devise-i18n", "~> 1.16"
gem 'csv'

# ==========================================
# 5. DEPLOYMENT (CI/CD)
# ==========================================
gem "kamal", require: false
gem "thruster", require: false

# ==========================================
# 6. GRUPOS DE AMBIENTE (Scrum Squad Tools)
# ==========================================
group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "factory_bot_rails", "~> 6.5"
  gem "faker", "~> 3.8"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
gem "heroicon", "~> 1.0"
