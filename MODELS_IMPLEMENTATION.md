# Implementação dos Modelos - Sistema de Controle de Estoque

## ✅ Status: CONCLUÍDO

Todos os modelos e migrações foram implementados com sucesso conforme especificado no [`ARCHITECTURE.md`](ARCHITECTURE.md:1).

---

## 📋 Modelos Criados

### 1. User (Usuário)
**Arquivo**: [`app/models/user.rb`](app/models/user.rb:1)

**Características implementadas:**
- ✅ Autenticação via Devise
- ✅ Enum `role`: admin (0), manager (1), operator (2) - default: operator
- ✅ Soft delete com `acts_as_paranoid`
- ✅ Auditoria com `has_paper_trail`
- ✅ Relacionamento: `has_many :stock_movements`

**Validações:**
- Email: presença, unicidade (Devise)
- Name: presença, mínimo 3 caracteres
- Role: presença

**Campos:**
- `email` (string, unique, not null)
- `encrypted_password` (string, not null)
- `name` (string, not null)
- `role` (integer, default: 2, not null)
- `active` (boolean, default: true, not null)
- `deleted_at` (datetime)

---

### 2. Category (Categoria)
**Arquivo**: [`app/models/category.rb`](app/models/category.rb:1)

**Características implementadas:**
- ✅ Soft delete com `acts_as_paranoid`
- ✅ Auditoria com `has_paper_trail`
- ✅ Relacionamento: `has_many :products`
- ✅ Método `toggle_active!`

**Validações:**
- Name: presença, unicidade, máximo 100 caracteres
- Description: máximo 500 caracteres (opcional)

**Campos:**
- `name` (string, unique, not null)
- `description` (text)
- `active` (boolean, default: true, not null)
- `deleted_at` (datetime)

**Índices:**
- `name` (unique)
- `active`
- `deleted_at`

---

### 3. Supplier (Fornecedor)
**Arquivo**: [`app/models/supplier.rb`](app/models/supplier.rb:1)

**Características implementadas:**
- ✅ Soft delete com `acts_as_paranoid`
- ✅ Auditoria com `has_paper_trail`
- ✅ Relacionamento: `has_many :products`
- ✅ Validação de CNPJ (14 dígitos)
- ✅ Método `formatted_cnpj` para formatação
- ✅ Método `toggle_active!`

**Validações:**
- Name: presença, mínimo 3 caracteres
- CNPJ: presença, unicidade, formato (14 dígitos)
- Email: formato válido (opcional)
- Phone: formato válido 10-11 dígitos (opcional)

**Campos:**
- `name` (string, not null)
- `cnpj` (string, unique, not null)
- `email` (string)
- `phone` (string)
- `address` (text)
- `contact_person` (string)
- `active` (boolean, default: true, not null)
- `deleted_at` (datetime)

**Índices:**
- `cnpj` (unique)
- `active`
- `deleted_at`

---

### 4. Product (Produto)
**Arquivo**: [`app/models/product.rb`](app/models/product.rb:1)

**Características implementadas:**
- ✅ Soft delete com `acts_as_paranoid`
- ✅ Auditoria com `has_paper_trail`
- ✅ Enum `unit_of_measure`: unit (0), kg (1), liter (2), meter (3), box (4), package (5)
- ✅ Relacionamentos: `belongs_to :category`, `belongs_to :supplier`, `has_many :stock_movements`
- ✅ Métodos de negócio: `low_stock?`, `out_of_stock?`, `profit_margin`, `update_stock`
- ✅ Método `toggle_active!`

**Validações:**
- SKU: presença, unicidade, formato alfanumérico com hífens
- Name: presença, 3-200 caracteres
- Selling_price: presença, maior que 0
- Cost_price: maior ou igual a 0 (opcional)
- Current_stock: maior ou igual a 0
- Minimum_stock: maior ou igual a 0
- Maximum_stock: maior que minimum_stock (opcional)
- Category e Supplier: presença
- Validação customizada: selling_price > cost_price

**Campos:**
- `sku` (string, unique, not null)
- `name` (string, not null)
- `description` (text)
- `category_id` (bigint, FK, not null)
- `supplier_id` (bigint, FK, not null)
- `unit_of_measure` (integer, default: 0, not null)
- `cost_price` (decimal 10,2)
- `selling_price` (decimal 10,2, not null)
- `current_stock` (decimal 10,2, default: 0, not null)
- `minimum_stock` (decimal 10,2, default: 0)
- `maximum_stock` (decimal 10,2)
- `active` (boolean, default: true, not null)
- `deleted_at` (datetime)

**Índices:**
- `sku` (unique)
- `category_id`
- `supplier_id`
- `active`
- `current_stock`
- `deleted_at`

**Scopes:**
- `active`, `inactive`, `low_stock`, `out_of_stock`
- `by_category`, `by_supplier`, `search`

---

### 5. StockMovement (Movimentação de Estoque)
**Arquivo**: [`app/models/stock_movement.rb`](app/models/stock_movement.rb:1)

**Características implementadas:**
- ✅ Auditoria com `has_paper_trail`
- ✅ Enum `movement_type`: entry (0), exit (1), adjustment (2), return (3)
- ✅ Relacionamentos: `belongs_to :product`, `belongs_to :user`
- ✅ Callback `after_create :update_product_stock`
- ✅ Método `total_value` para cálculo

**Validações:**
- Product, User, Movement_type: presença
- Quantity: presença, maior que 0
- Unit_cost: maior que 0 (opcional)
- Movement_date: presença, não pode ser futuro
- Validação customizada: estoque suficiente para saídas

**Campos:**
- `product_id` (bigint, FK, not null)
- `user_id` (bigint, FK, not null)
- `movement_type` (integer, not null)
- `quantity` (decimal 10,2, not null)
- `unit_cost` (decimal 10,2)
- `reason` (text)
- `reference_document` (string)
- `movement_date` (datetime, not null)

**Índices:**
- `product_id`
- `user_id`
- `movement_type`
- `movement_date`
- `[product_id, movement_date]` (composto)

**Scopes:**
- `by_product`, `by_user`, `by_type`, `by_date_range`
- `recent`, `entries`, `exits`

---

## 🗄️ Estrutura do Banco de Dados

### Tabelas Criadas:
1. ✅ `users` - Usuários do sistema
2. ✅ `categories` - Categorias de produtos
3. ✅ `suppliers` - Fornecedores
4. ✅ `products` - Produtos do estoque
5. ✅ `stock_movements` - Movimentações de estoque

### Foreign Keys:
- `products.category_id` → `categories.id`
- `products.supplier_id` → `suppliers.id`
- `stock_movements.product_id` → `products.id`
- `stock_movements.user_id` → `users.id`

### Índices Implementados:
- **Users**: email (unique), reset_password_token (unique), role, deleted_at
- **Categories**: name (unique), active, deleted_at
- **Suppliers**: cnpj (unique), active, deleted_at
- **Products**: sku (unique), category_id, supplier_id, active, current_stock, deleted_at
- **StockMovements**: product_id, user_id, movement_type, movement_date, [product_id, movement_date]

---

## 🔧 Funcionalidades Implementadas

### Soft Delete (Paranoia)
Todos os modelos principais (exceto StockMovement) implementam soft delete:
- User
- Category
- Supplier
- Product

### Auditoria (PaperTrail)
Todos os modelos implementam auditoria completa de mudanças:
- User
- Category
- Supplier
- Product
- StockMovement

### Enums
- **User.role**: admin, manager, operator
- **Product.unit_of_measure**: unit, kg, liter, meter, box, package
- **StockMovement.movement_type**: entry, exit, adjustment, return

### Relacionamentos
```
User (1) ──────────> (N) StockMovement
                           │
                           │
                           ▼
Category (1) ──────> (N) Product (N) <────── (1) Supplier
                           │
                           │
                           ▼
                     (N) StockMovement
```

---

## 📊 Migrações Executadas

1. ✅ `20251029155444_devise_create_users.rb` - Criação da tabela users (Devise)
2. ✅ `20251029155508_add_fields_to_users.rb` - Campos customizados do User
3. ✅ `20251029155531_create_categories.rb` - Criação da tabela categories
4. ✅ `20251029155551_create_suppliers.rb` - Criação da tabela suppliers
5. ✅ `20251029155606_create_products.rb` - Criação da tabela products
6. ✅ `20251029155629_create_stock_movements.rb` - Criação da tabela stock_movements

**Status**: Todas as migrações executadas com sucesso ✅

---

## 🎯 Regras de Negócio Implementadas

### Produtos
- ✅ SKU único no sistema
- ✅ Validação: preço de venda > preço de custo
- ✅ Estoque não pode ser negativo
- ✅ Soft delete (produtos são desativados, não deletados)
- ✅ Categoria e fornecedor obrigatórios

### Movimentações de Estoque
- ✅ Tipos: entrada, saída, ajuste, devolução
- ✅ Quantidade sempre positiva
- ✅ Saída não pode resultar em estoque negativo
- ✅ Data não pode ser futura
- ✅ Atualização automática do estoque após criação
- ✅ Registro do usuário responsável

### Validações de Dados
- ✅ CNPJ: 14 dígitos numéricos
- ✅ Email: formato válido
- ✅ Telefone: 10-11 dígitos
- ✅ SKU: alfanumérico com hífens
- ✅ Preços: valores decimais com 2 casas

---

## 🧪 Próximos Passos

A implementação dos modelos está completa. Os próximos passos sugeridos são:

1. **Controllers e Views**
   - Implementar controllers para cada modelo
   - Criar views para CRUD completo
   - Implementar dashboard com métricas

2. **Autorização (Pundit)**
   - Criar policies para cada modelo
   - Implementar controle de acesso por role

3. **Testes**
   - Specs para validações
   - Specs para relacionamentos
   - Specs para métodos de negócio
   - Specs para callbacks

4. **Seeds**
   - Criar dados de exemplo
   - Usuários de teste para cada role
   - Categorias, fornecedores e produtos de exemplo

5. **Relatórios**
   - Implementar geração de relatórios
   - Exportação em PDF/CSV/Excel

---

## 📝 Notas Técnicas

### Dependências Utilizadas
- `devise` - Autenticação de usuários
- `paranoia` - Soft delete
- `paper_trail` - Auditoria de mudanças
- `pundit` - Autorização (configurado, não usado ainda)

### Convenções Seguidas
- Nomes de tabelas no plural
- Foreign keys com sufixo `_id`
- Timestamps automáticos (created_at, updated_at)
- Soft delete com campo `deleted_at`
- Enums com valores inteiros começando em 0

### Banco de Dados
- PostgreSQL 14+
- Encoding: UTF-8
- Timezone: UTC

---

## ✅ Checklist de Implementação

- [x] Modelo User com Devise
- [x] Campos customizados do User (name, role, active, deleted_at)
- [x] Modelo Category
- [x] Modelo Supplier
- [x] Modelo Product
- [x] Modelo StockMovement
- [x] Todas as validações implementadas
- [x] Enums configurados (role, unit_of_measure, movement_type)
- [x] Soft delete (acts_as_paranoid)
- [x] Auditoria (has_paper_trail)
- [x] Relacionamentos (has_many, belongs_to)
- [x] Índices de banco de dados
- [x] Migrações executadas com sucesso
- [x] Schema.rb atualizado

---

**Data de Conclusão**: 29 de Outubro de 2025
**Desenvolvido por**: AI Cockpit
**Versão do Rails**: 7.2
**Versão do Ruby**: 3.2+