# Expense Management API

A Ruby on Rails API-only application for managing employee expenses with role-based approval workflow.

## System Requirements

- **Ruby**: 3.4.5
- **Rails**: 8.0.3
- **PostgreSQL**: 16.10

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/expense_api.git
cd expense_api
```

### 2. Install Dependencies
```bash
# Install Ruby gems
bundle install
```

### 3. Database Setup
```bash
# Create and setup the database
rails db:create
rails db:migrate
rails db:seed
```

### 4. Start the Application
```bash
# Start Rails API server
rails server
```
