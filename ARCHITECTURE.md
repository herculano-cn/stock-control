
# Sistema de Controle de Estoque - Arquitetura

## Visão Geral

Sistema de controle de estoque desenvolvido em Ruby on Rails para gerenciar produtos, categorias, fornecedores e movimentações de estoque.

## Stack Tecnológica

- **Framework**: Ruby on Rails 7.1+
- **Ruby**: 3.2+
- **Banco de Dados**: PostgreSQL 14+
- **Frontend**: Hotwire (Turbo + Stimulus)
- **Autenticação**: Devise
- **Autorização**: Pundit

---

## Modelos de Dados

### 1. User (Usuário)
Gerencia os usuários do sistema com diferentes níveis de acesso.

**Atributos:**
- `id`: bigint (PK)
- `email`: string (unique, not null)
- `encrypted_password`: string (not null)
- `name`: string (not null)
- `role`: enum [:admin, :manager, :operator] (default: :operator)
- `active`: boolean (default: true)
- `created_at`: datetime
- `updated_at`: datetime

**Validações:**
- Email: presença, formato válido, unicidade
- Name: presença, tamanho mínimo 3 caracteres
- Role: presença, inclusão na lista de roles

**Relacionamentos:**
- `has_many :stock_movements`

---

### 2. Category (Categoria)
Organiza produtos em categorias hierárquicas.

**Atributos:**
- `id`: bigint (PK)
- `name`: string (not null)
- `description`: text
- `active`: boolean (default: true)
- `created_at`: datetime
- `updated_at`: datetime

**Validações:**
- Name: presença, unicidade, tamanho máximo 100 caracteres
- Description: tamanho máximo 500 caracteres

**Relacionamentos:**
- `has_many :products`

**Índices:**
- `index_categories_on_name` (unique)

---

### 3. Supplier (Fornecedor)
Gerencia informações dos fornecedores.

**Atributos:**
- `id`: bigint (PK)
- `name`: string (not null)
- `cnpj`: string (unique)
- `email`: string
- `phone`: string
- `address`: text
- `active`: boolean (default: true)
- `created_at`: datetime
- `updated_at`: datetime

**Validações:**
- Name: presença, tamanho mínimo 3 caracteres
- CNPJ: formato válido (14 dígitos), unicidade
- Email: formato válido (se presente)
- Phone: formato válido (se presente)

**Relacionamentos:**
- `has_many :products`

**Índices:**
- `index_suppliers_on_cnpj` (unique)
- `index_suppliers_on_active`

---

### 4. Product (Produto)
Representa os produtos do estoque.

**Atributos:**
- `id`: bigint (PK)
- `sku`: string (unique, not null)
- `name`: string (not null)
- `description`: text
- `category_id`: bigint (FK)
- `supplier_id`: bigint (FK)
- `unit_price`: decimal(10,2) (not null)
- `cost_price`: decimal(10,2)
- `current_stock`: integer (default: 0, not null)
- `minimum_stock`: integer (default: 0)
- `maximum_stock`: integer
- `unit_of_measure`: enum [:unit, :kg, :liter, :meter, :box] (default: :unit)
- `active`: boolean (default: true)
- `created_at`: datetime
- `updated_at`: datetime

**Validações:**
- SKU: presença, unicidade, formato alfanumérico
- Name: presença, tamanho mínimo 3 caracteres
- Unit_price: presença, maior que 0
- Cost_price: maior ou igual a 0 (se presente)
- Current_stock: maior ou igual a 0
- Minimum_stock: maior ou igual a 0
- Maximum_stock: maior que minimum_stock (se presente)
- Category: presença
- Supplier: presença

**Relacionamentos:**
- `belongs_to :category`
- `belongs_to :supplier`
- `has_many :stock_movements`

**Métodos de Negócio:**
- `low_stock?`: verifica se está abaixo do estoque mínimo
- `out_of_stock?`: verifica se está sem estoque
- `profit_margin`: calcula margem de lucro
- `update_stock(quantity, type)`: atualiza estoque baseado no tipo de movimentação

**Índices:**
- `index_products_on_sku` (unique)
- `index_products_on_category_id`
- `index_products_on_supplier_id`
- `index_products_on_active`
- `index_products_on_current_stock`

---

### 5. StockMovement (Movimentação de Estoque)
Registra todas as movimentações de entrada e saída de produtos.

**Atributos:**
- `id`: bigint (PK)
- `product_id`: bigint (FK, not null)
- `user_id`: bigint (FK, not null)
- `movement_type`: enum [:entry, :exit, :adjustment, :return] (not null)
- `quantity`: integer (not null)
- `unit_price`: decimal(10,2)
- `total_value`: decimal(10,2)
- `reason`: string
- `notes`: text
- `reference_number`: string
- `movement_date`: date (not null)
- `created_at`: datetime
- `updated_at`: datetime

**Validações:**
- Product: presença
- User: presença
- Movement_type: presença, inclusão na lista
- Quantity: presença, maior que 0
- Unit_price: maior que 0 (se presente)
- Movement_date: presença, não pode ser futuro

**Relacionamentos:**
- `belongs_to :product`
- `belongs_to :user`

**Callbacks:**
- `before_create :calculate_total_value`
- `after_create :update_product_stock`
- `before_destroy :prevent_deletion` (apenas admin pode deletar)

**Métodos de Negócio:**
- `calculate_total_value`: calcula valor total da movimentação
- `update_product_stock`: atualiza estoque do produto

**Índices:**
- `index_stock_movements_on_product_id`
- `index_stock_movements_on_user_id`
- `index_stock_movements_on_movement_type`
- `index_stock_movements_on_movement_date`

---

## Diagrama de Relacionamentos (ERD)

```
┌─────────────────┐
│     User        │
│─────────────────│
│ id              │
│ email           │
│ name            │
│ role            │
└────────┬────────┘
         │
         │ has_many
         │
         ▼
┌─────────────────────┐
│  StockMovement      │
│─────────────────────│
│ id                  │
│ product_id (FK)     │
│ user_id (FK)        │
│ movement_type       │
│ quantity            │
│ movement_date       │
└──────────┬──────────┘
           │
           │ belongs_to
           │
           ▼
┌──────────────────────┐       ┌─────────────────┐
│      Product         │───────│    Category     │
│──────────────────────│       │─────────────────│
│ id                   │       │ id              │
│ sku                  │       │ name            │
│ name                 │       │ description     │
│ category_id (FK)     │───────│                 │
│ supplier_id (FK)     │       └─────────────────┘
│ current_stock        │
│ minimum_stock        │
│ unit_price           │
└──────────┬───────────┘
           │
           │ belongs_to
           │
           ▼
┌─────────────────┐
│    Supplier     │
│─────────────────│
│ id              │
│ name            │
│ cnpj            │
│ email           │
└─────────────────┘
```

---

## Controllers

### 1. ApplicationController
**Responsabilidades:**
- Configuração base para todos os controllers
- Autenticação via Devise
- Tratamento de exceções globais
- Configuração de parâmetros permitidos

**Métodos:**
- `authenticate_user!`
- `current_user`
- `authorize_action`

---

### 2. DashboardController
**Ações:**
- `index`: Dashboard principal com métricas e gráficos

**Métricas exibidas:**
- Total de produtos
- Produtos com estoque baixo
- Valor total do estoque
- Movimentações recentes
- Produtos mais vendidos

---

### 3. ProductsController
**Ações:**
- `index`: Lista todos os produtos (com filtros e paginação)
- `show`: Exibe detalhes do produto e histórico de movimentações
- `new`: Formulário para novo produto
- `create`: Cria novo produto
- `edit`: Formulário de edição
- `update`: Atualiza produto
- `destroy`: Desativa produto (soft delete)

**Filtros:**
- Por categoria
- Por fornecedor
- Por status (ativo/inativo)
- Por nível de estoque (baixo, normal, alto)
- Busca por nome ou SKU

**Autorização:**
- Index/Show: todos os usuários autenticados
- New/Create/Edit/Update: managers e admins
- Destroy: apenas admins

---

### 4. CategoriesController
**Ações:**
- `index`: Lista categorias
- `show`: Exibe categoria e produtos relacionados
- `new`: Formulário para nova categoria
- `create`: Cria categoria
- `edit`: Formulário de edição
- `update`: Atualiza categoria
- `destroy`: Desativa categoria

**Autorização:**
- Index/Show: todos os usuários
- New/Create/Edit/Update/Destroy: managers e admins

---

### 5. SuppliersController
**Ações:**
- `index`: Lista fornecedores
- `show`: Exibe fornecedor e produtos relacionados
- `new`: Formulário para novo fornecedor
- `create`: Cria fornecedor
- `edit`: Formulário de edição
- `update`: Atualiza fornecedor
- `destroy`: Desativa fornecedor

**Autorização:**
- Index/Show: todos os usuários
- New/Create/Edit/Update/Destroy: managers e admins

---

### 6. StockMovementsController
**Ações:**
- `index`: Lista movimentações (com filtros)
- `show`: Exibe detalhes da movimentação
- `new`: Formulário para nova movimentação
- `create`: Cria movimentação e atualiza estoque
- `destroy`: Remove movimentação (apenas admin)

**Filtros:**
- Por produto
- Por tipo de movimentação
- Por período
- Por usuário

**Autorização:**
- Index/Show: todos os usuários
- New/Create: operators, managers e admins
- Destroy: apenas admins

---

### 7. ReportsController
**Ações:**
- `index`: Lista de relatórios disponíveis
- `stock_status`: Relatório de status do estoque
- `movements`: Relatório de movimentações
- `low_stock`: Produtos com estoque baixo
- `valuation`: Valorização do estoque

**Formatos de exportação:**
- HTML
- PDF (via gem Prawn)
- CSV
- Excel (via gem Caxlsx)

**Autorização:**
- Todos: managers e admins
- Operators: apenas visualização de stock_status e low_stock

---

## Rotas

```ruby
# config/routes.rb

Rails.application.routes.draw do
  # Devise para autenticação
  devise_for :users
  
  # Root
  root 'dashboard#index'
  
  # Dashboard
  get 'dashboard', to: 'dashboard#index'
  
  # Resources principais
  resources :products do
    collection do
      get :low_stock
      get :out_of_stock
    end
    member do
      patch :toggle_active
    end
    resources :stock_movements, only: [:index, :new, :create]
  end
  
  resources :categories do
    member do
      patch :toggle_active
    end
  end
  
  resources :suppliers do
    member do
      patch :toggle_active
    end
  end
  
  resources :stock_movements, only: [:index, :show, :destroy] do
    collection do
      get :entries
      get :exits
    end
  end
  
  # Relatórios
  namespace :reports do
    get :index
    get :stock_status
    get :movements
    get :low_stock
    get :valuation
  end
  
  # API (opcional para futuras integrações)
  namespace :api do
    namespace :v1 do
      resources :products, only: [:index, :show]
      resources :stock_movements, only: [:index, :create]
    end
  end
end
```

---

## Gems Recomendadas

### Essenciais
```ruby
# Gemfile

# Autenticação
gem 'devise', '~> 4.9'

# Autorização
gem 'pundit', '~> 2.3'

# Paginação
gem 'kaminari', '~> 1.2'

# Busca e filtros
gem 'ransack', '~> 4.0'

# Formulários
gem 'simple_form', '~> 5.3'

# Frontend
gem 'hotwire-rails', '~> 0.1'
gem 'stimulus-rails', '~> 1.3'
gem 'turbo-rails', '~> 1.5'

# UI/CSS
gem 'tailwindcss-rails', '~> 2.0'
# ou
gem 'bootstrap', '~> 5.3'
```

### Relatórios e Exportação
```ruby
# PDF
gem 'prawn', '~> 2.4'
gem 'prawn-table', '~> 0.2'

# Excel
gem 'caxlsx', '~> 3.4'
gem 'caxlsx_rails', '~> 0.6'

# Gráficos
gem 'chartkick', '~> 5.0'
gem 'groupdate', '~> 6.4'
```

### Desenvolvimento e Testes
```ruby
group :development, :test do
  gem 'rspec-rails', '~> 6.1'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.2'
  gem 'pry-rails', '~> 0.3'
  gem 'bullet', '~> 7.1'
end

group :test do
  gem 'shoulda-matchers', '~> 6.0'
  gem 'database_cleaner-active_record', '~> 2.1'
  gem 'simplecov', '~> 0.22', require: false
end

group :development do
  gem 'annotate', '~> 3.2'
  gem 'rubocop-rails', '~> 2.23', require: false
  gem 'brakeman', '~> 6.1', require: false
end
```

### Produção
```ruby
# Performance
gem 'rack-mini-profiler', '~> 3.3'
gem 'redis', '~> 5.0'

# Monitoramento
gem 'sentry-ruby', '~> 5.16'
gem 'sentry-rails', '~> 5.16'

# Background Jobs
gem 'sidekiq', '~> 7.2'
```

---

## Estrutura de Pastas

```
app/
├── controllers/
│   ├── application_controller.rb
│   ├── dashboard_controller.rb
│   ├── products_controller.rb
│   ├── categories_controller.rb
│   ├── suppliers_controller.rb
│   ├── stock_movements_controller.rb
│   ├── reports_controller.rb
│   ├── concerns/
│   │   ├── authenticable.rb
│   │   └── authorizable.rb
│   └── api/
│       └── v1/
│           ├── base_controller.rb
│           ├── products_controller.rb
│           └── stock_movements_controller.rb
│
├── models/
│   ├── application_record.rb
│   ├── user.rb
│   ├── product.rb
│   ├── category.rb
│   ├── supplier.rb
│   ├── stock_movement.rb
│   └── concerns/
│       ├── activable.rb
│       └── searchable.rb
│
├── views/
│   ├── layouts/
│   │   ├── application.html.erb
│   │   └── _navigation.html.erb
│   ├── dashboard/
│   │   └── index.html.erb
│   ├── products/
│   │   ├── index.html.erb
│   │   ├── show.html.erb
│   │   ├── new.html.erb
│   │   ├── edit.html.erb
│   │   └── _form.html.erb
│   ├── categories/
│   │   ├── index.html.erb
│   │   ├── show.html.erb
│   │   └── _form.html.erb
│   ├── suppliers/
│   │   ├── index.html.erb
│   │   ├── show.html.erb
│   │   └── _form.html.erb
│   ├── stock_movements/
│   │   ├── index.html.erb
│   │   ├── show.html.erb
│   │   ├── new.html.erb
│   │   └── _form.html.erb
│   ├── reports/
│   │   ├── index.html.erb
│   │   ├── stock_status.html.erb
│   │   ├── movements.html.erb
│   │   └── low_stock.html.erb
│   └── shared/
│       ├── _flash_messages.html.erb
│       ├── _pagination.html.erb
│       └── _filters.html.erb
│
├── services/
│   ├── stock/
│   │   ├── movement_processor.rb
│   │   ├── valuation_calculator.rb
│   │   └── low_stock_notifier.rb
│   └── reports/
│       ├── stock_report_generator.rb
│       └── movement_report_generator.rb
│
├── policies/
│   ├── application_policy.rb
│   ├── product_policy.rb
│   ├── category_policy.rb
│   ├── supplier_policy.rb
│   ├── stock_movement_policy.rb
│   └── report_policy.rb
│
├── queries/
│   ├── products_query.rb
│   ├── stock_movements_query.rb
│   └── reports_query.rb
│
├── decorators/
│   ├── product_decorator.rb
│   └── stock_movement_decorator.rb
│
├── javascript/
│   ├── controllers/
│   │   ├── product_form_controller.js
│   │   ├── stock_movement_controller.js
│   │   └── search_controller.js
│   └── application.js
│
└── assets/
    ├── stylesheets/
    │   ├── application.css
    │   ├── products.css
    │   └── dashboard.css
    └── images/

config/
├── routes.rb
├── database.yml
├── application.rb
├── environments/
│   ├── development.rb
│   ├── test.rb
│   └── production.rb
└── initializers/
    ├── devise.rb
    ├── kaminari.rb
    └── simple_form.rb

db/
├── migrate/
│   ├── 20240101000001_devise_create_users.rb
│   ├── 20240101000002_create_categories.rb
│   ├── 20240101000003_create_suppliers.rb
│   ├── 20240101000004_create_products.rb
│   └── 20240101000005_create_stock_movements.rb
├── seeds.rb
└── schema.rb

spec/
├── models/
│   ├── user_spec.rb
│   ├── product_spec.rb
│   ├── category_spec.rb
│   ├── supplier_spec.rb
│   └── stock_movement_spec.rb
├── controllers/
├── services/
├── policies/
├── factories/
│   ├── users.rb
│   ├── products.rb
│   ├── categories.rb
│   ├── suppliers.rb
│   └── stock_movements.rb
└── rails_helper.rb
```

---

## Regras de Negócio

### Produtos
1. **SKU único**: Cada produto deve ter um SKU único no sistema
2. **Estoque mínimo**: Sistema deve alertar quando produto atingir estoque mínimo
3. **Validação de preços**: Preço de venda deve ser maior que preço de custo
4. **Soft delete**: Produtos não são deletados, apenas desativados
5. **Categoria obrigatória**: Todo produto deve pertencer a uma categoria
6. **Fornecedor obrigatório**: Todo produto deve ter um fornecedor

### Movimentações de Estoque
1. **Tipos de movimentação**:
   - **Entrada**: Aumenta estoque (compras, devoluções de clientes)
   - **Saída**: Diminui estoque (vendas, perdas)
   - **Ajuste**: Correção de estoque (inventário)
   - **Devolução**: Devolução para fornecedor

2. **Validações**:
   - Quantidade deve ser sempre positiva
   - Saída não pode resultar em estoque negativo
   - Data da movimentação não pode ser futura
   - Movimentações só podem ser deletadas por administradores

3. **Auditoria**:
   - Todas as movimentações são registradas com usuário responsável
   - Histórico completo de movimentações por produto
   - Impossível editar movimentações (apenas criar ou deletar)

### Permissões por Role

#### Operator (Operador)
- Visualizar produtos, categorias e fornecedores
- Criar movimentações de entrada e saída
- Visualizar relatórios básicos de estoque

#### Manager (Gerente)
- Todas as permissões de Operator
- Criar, editar e desativar produtos
- Criar, editar e desativar categorias e fornecedores
- Visualizar todos os relatórios
- Exportar relatórios

#### Admin (Administrador)
- Todas as permissões de Manager
- Deletar movimentações
- Gerenciar usuários
- Acessar configurações do sistema
- Visualizar logs de auditoria

---

## Validações Detalhadas

### Product
```ruby
validates :sku, presence: true, uniqueness: true, 
          format: { with: /\A[A-Z0-9\-]+\z/ }
validates :name, presence: true, length: { minimum: 3, maximum: 200 }
validates :unit_price, presence: true, numericality: { greater_than: 0 }
validates :cost_price, numericality: { greater_than_or_equal_to: 0 }, 
          allow_nil: true
validates :current_stock, numericality: { greater_than_or_equal_to: 0 }
validates :minimum_stock, numericality: { greater_than_or_equal_to: 0 }
validates :maximum_stock, numericality: { greater_than: :minimum_stock }, 
          allow_nil: true
validates :category, :supplier, presence: true
validate :unit_price_greater_than_cost_price

private

def unit_price_greater_than_cost_price
  if cost_price.present? && unit_price <= cost_price
    errors.add(:unit_price, "must be greater than cost price")
  end
end
```

### StockMovement
```ruby
validates :product, :user, :movement_type, presence: true
validates :quantity, presence: true, numericality: { greater_than: 0 }
validates :movement_date, presence: true
validate :movement_date_not_in_future
validate :sufficient_stock_for_exit

private

def movement_date_not_in_future
  if movement_date.present? && movement_date > Date.today
    errors.add(:movement_date, "cannot be in the future")
  end
end

def sufficient_stock_for_exit
  if movement_type == 'exit' && product.present?
    if quantity > product.current_stock
      errors.add(:quantity, "exceeds available stock")
    end
  end
end
```

---

## Índices de Banco de Dados

```ruby
# db/migrate/..._add_indexes.rb

add_index :products, :sku, unique: true
add_index :products, :category_id
add_index :products, :supplier_id
add_index :products, :active
add_index :products, :current_stock
add_index :products, [:category_id, :active]

add_index :categories, :name, unique: true
add_index :categories, :active

add_index :suppliers, :cnpj, unique: true
add_index :suppliers, :active

add_index :stock_movements, :product_id
add_index :stock_movements, :user_id
add_index :stock_movements, :movement_type
add_index :stock_movements, :movement_date
add_index :stock_movements, [:product_id, :movement_date]
add_index :stock_movements, [:movement_type, :movement_date]

add_index :users, :email, unique: true
add_index :users, :role
```

---

## Concerns Reutilizáveis

### Activable
```ruby
# app/models/concerns/activable.rb
module Activable
  extend ActiveSupport::Concern
  
  included do
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
  end
  
  def toggle_active!
    update(active: !active)
  end
end
```

### Searchable
```ruby
# app/models/concerns/searchable.rb
module Searchable
  extend ActiveSupport::Concern
  
  included do
    scope :search, ->(term) {
      where("name ILIKE ?", "%#{term}%")
    }
  end
end
```

---

## Services

### Stock::MovementProcessor
**Responsabilidade**: Processar movimentações de estoque

**Métodos:**
- `process(movement)`: Processa uma movimentação
- `update_product_stock(product, quantity, type)`: Atualiza estoque do produto
- `validate_movement(movement)`: Valida regras de negócio

### Stock::ValuationCalculator
**Responsabilidade**: Calcular valorização do estoque

**Métodos:**
- `calculate_total_value`: Calcula valor total do estoque
- `calculate_by_category`: Calcula valor por categoria
- `calculate_profit_margin`: Calcula margem de lucro total

### Reports::StockReportGenerator
**Responsabilidade**: Gerar relatórios de estoque

**Métodos:**
- `generate(format:)`: Gera relatório no formato especificado
- `to_pdf`: Exporta para PDF
- `to_csv`: Exporta para CSV
- `to_excel`: Exporta para Excel

---

## Testes

### Cobertura Esperada
- **Models**: 100% de cobertura
- **Controllers**: 90%+ de cobertura
- **Services**: 100% de cobertura
- **Policies**: 100% de cobertura

### Tipos de Testes

#### Unit Tests (Models)
- Validações
- Relacionamentos
- Métodos de instância
- Scopes
- Callbacks

#### Integration Tests (Controllers)
- Fluxos completos de CRUD
- Autorização
- Filtros e buscas
- Exportação de relatórios

#### Service Tests
- Lógica de negócio
- Cálculos
- Processamento de movimentações

---

## Segurança

### Autenticação
- Devise com confirmação de email
- Senha forte (mínimo 8 caracteres, letras e números)
- Bloqueio após 5 tentativas falhas
- Timeout de sessão após 30 minutos de inatividade

### Autorização
- Pundit para controle de acesso baseado em roles
- Políticas específicas por recurso
- Verificação em todos os endpoints

### Proteções
- CSRF protection habilitado
- SQL injection prevention (ActiveRecord)
- XSS protection (sanitização de inputs)
- Rate limiting em API
- HTTPS obrigatório em produção

---

## Performance

### Otimizações
- Eager loading para evitar N+1 queries
- Paginação em todas as listagens
- Cache de queries frequentes
- Índices em colunas de busca e foreign keys
- Background jobs para relatórios pesados

### Monitoramento
- Bullet para detectar N+1 queries
- Rack Mini Profiler em desenvolvimento
- Sentry para tracking de erros
- Logs estruturados

---

## Deployment

### Requisitos de Produção
- Ruby 3.2+
- Rails 7.1+
- PostgreSQL 14+
- Redis (para cache e jobs)
- Servidor web: Puma
- Reverse proxy: Nginx

### Variáveis de Ambiente
```bash
DATABASE_URL=postgresql://...
REDIS_URL=redis://...
SECRET_KEY_BASE=...
RAILS_ENV=production
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
```

### Checklist de Deploy
- [ ] Executar migrations
- [ ] Compilar assets
- [ ] Configurar variáveis de ambiente
- [ ] Configurar backup de banco de dados
- [ ] Configurar SSL/TLS
- [ ] Configurar monitoramento
- [ ] Testar em staging antes de produção

---

## Próximos Passos (Roadmap)

### Fase 1 - MVP (4-6 semanas)
-