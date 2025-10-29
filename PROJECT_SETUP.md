# Inventory Control System - Project Setup

## Overview
This document tracks the setup progress for the Ruby on Rails inventory control system.

## System Requirements
- Ruby: 3.2.9 (via rbenv)
- Rails: 7.1+
- PostgreSQL: 14+
- Bundler: Latest

## Setup Progress

### Phase 1: Ruby Environment ✓
- [x] Install Homebrew
- [x] Install rbenv and ruby-build
- [x] Install Ruby 3.2.9 (in progress)
- [ ] Set Ruby 3.2.9 as local version
- [ ] Install bundler gem
- [ ] Install Rails gem

### Phase 2: Rails Project Creation
- [ ] Create new Rails app with PostgreSQL
- [ ] Configure Gemfile with required gems
- [ ] Run bundle install
- [ ] Configure database.yml
- [ ] Create databases (development, test)

### Phase 3: Essential Gems Configuration
- [ ] Install and configure Devise (authentication)
- [ ] Install and configure Pundit (authorization)
- [ ] Install and configure Kaminari (pagination)
- [ ] Install and configure Ransack (search)
- [ ] Install reporting gems (Prawn, Caxlsx)
- [ ] Install charting gems (Chartkick, Groupdate)
- [ ] Install utility gems (Paranoia, PaperTrail, etc.)

### Phase 4: Project Documentation
- [ ] Create comprehensive README.md
- [ ] Document setup instructions
- [ ] Document development workflow
- [ ] Document deployment process

## Required Gems (from ARCHITECTURE.md)

### Authentication & Authorization
- devise (~> 4.9)
- pundit (~> 2.3)

### UI & Frontend
- hotwire-rails (~> 0.1)
- stimulus-rails (~> 1.3)
- turbo-rails (~> 1.5)
- tailwindcss-rails (~> 2.0) OR bootstrap (~> 5.3)
- simple_form (~> 5.3)

### Data Management
- kaminari (~> 1.2) - Pagination
- ransack (~> 4.0) - Search and filtering

### Reporting & Export
- prawn (~> 2.4) - PDF generation
- prawn-table (~> 0.2) - PDF tables
- caxlsx (~> 3.4) - Excel generation
- caxlsx_rails (~> 0.6) - Excel Rails integration

### Analytics & Visualization
- chartkick (~> 5.0) - Charts
- groupdate (~> 6.4) - Date grouping for charts

### Utilities
- paranoia - Soft delete
- paper_trail - Auditing
- redis (~> 5.0) - Caching
- sidekiq (~> 7.2) - Background jobs

### Development & Testing
- rspec-rails (~> 6.1)
- factory_bot_rails (~> 6.4)
- faker (~> 3.2)
- pry-rails (~> 0.3)
- bullet (~> 7.1)
- shoulda-matchers (~> 6.0)
- database_cleaner-active_record (~> 2.1)
- simplecov (~> 0.22)
- annotate (~> 3.2)
- rubocop-rails (~> 2.23)
- brakeman (~> 6.1)

### Production
- rack-mini-profiler (~> 3.3)
- sentry-ruby (~> 5.16)
- sentry-rails (~> 5.16)

## Next Steps
Once Ruby 3.2.9 installation completes:
1. Verify Ruby version
2. Install bundler and Rails
3. Create Rails project
4. Configure all gems
5. Set up database
6. Create README with full instructions

## Architecture Reference
See ARCHITECTURE.md for complete system design including:
- 5 main models (User, Product, Category, Supplier, StockMovement)
- Controllers and routes
- Business rules and validations
- Security and performance considerations