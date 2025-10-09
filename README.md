# Expense Management API

A Ruby on Rails API-only application with a Next.js frontend for managing employee expenses with role-based approval workflow.

## System Requirements

- **Ruby**: 3.4.5
- **Rails**: 8.0.3
- **PostgreSQL**: 16.10

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/darwinlorenzopalonpon/expense_api.git
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
# Start Rails API server (localhost:3000)
rails server

# Open a new terminal cd into expense_api/frontend and run frontend app (localhost:3001)
cd frontend
npm run dev
```
open browser and navigate to **http://localhost:3001**

## Business Rules

### Expense States
- **drafted**: Only visible to creator, can be edited/deleted
- **submitted**: Visible to reviewers and associated employees, cannot be edited
- **approved**: Final state, cannot be changed
- **rejected**: Final state, cannot be changed

### User Roles
- **employee**: Can create, edit, delete, and submit their own expenses for review
- **reviewer**: Can approve or reject submitted expenses

### Authorization Rules
- Only employees can create/update/delete expenses
- Only expense owners can edit/delete/submit their own expenses
- Only drafted expenses can be edited or deleted
- Only reviewers can approve/reject submitted expenses

## Development

### Running Tests
```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/services/expense_create_service_spec.rb
```

## Tech Stack

- **Backend**: Ruby on Rails 8.0.3 (API)
- **Database**: PostgreSQL 16.10
- **Serialization**: Active Model Serializers
- **State Management**: AASM (Acts As State Machine)
- **Testing**: RSpec with FactoryBot
