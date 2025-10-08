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

## API Documentation

### Authentication

All API requests require a user ID in the header:
```
X-User-ID: 1
```

### Base URL
```
http://localhost:3000/api/v1
```

## Endpoints

### Users

#### List Users
```http
GET /api/v1/users
Headers: X-User-ID: 1
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "Employee 1",
    "email": "employee1@example.com",
    "role": "employee"
  },
  {
    "id": 3,
    "name": "Reviewer 1",
    "email": "reviewer1@example.com",
    "role": "reviewer"
  }
]
```

### Expenses

#### List Expenses
```http
GET /api/v1/expenses
Headers: X-User-ID: 1
```

**Response:**
```json
[
  {
    "id": 1,
    "amount": "50.00",
    "description": "Client lunch meeting",
    "state": "submitted",
    "submitted_at": "2025-10-08T10:30:00.000Z",
    "reviewed_at": null,
    "employee": {
      "id": 1,
      "name": "Employee 1",
      "email": "employee1@example.com",
      "role": "employee"
    },
    "reviewer": null
  }
]
```

#### Show Expense
```http
GET /api/v1/expenses/1
Headers: X-User-ID: 1
```

**Response:**
```json
{
  "id": 1,
  "amount": "50.00",
  "description": "Client lunch meeting",
  "state": "submitted",
  "submitted_at": "2025-10-08T10:30:00.000Z",
  "reviewed_at": null,
  "employee": {
    "id": 1,
    "name": "Employee 1",
    "email": "employee1@example.com",
    "role": "employee"
  },
  "reviewer": null
}
```

#### Create Expense
```http
POST /api/v1/expenses
Headers:
  X-User-ID: 1
  Content-Type: application/json

Body:
{
  "expense": {
    "amount": 75.50,
    "description": "Team dinner",
    "submit": false
  }
}
```

**Response (201 Created):**
```json
{
  "id": 2,
  "amount": "75.50",
  "description": "Team dinner",
  "state": "drafted",
  "submitted_at": null,
  "reviewed_at": null,
  "employee": {
    "id": 1,
    "name": "Employee 1",
    "email": "employee1@example.com",
    "role": "employee"
  },
  "reviewer": null
}
```

#### Create and Submit Expense
```http
POST /api/v1/expenses
Headers:
  X-User-ID: 1
  Content-Type: application/json

Body:
{
  "expense": {
    "amount": 100.00,
    "description": "Conference registration",
    "submit": true
  }
}
```

**Response (201 Created):**
```json
{
  "id": 3,
  "amount": "100.00",
  "description": "Conference registration",
  "state": "submitted",
  "submitted_at": "2025-10-08T11:00:00.000Z",
  "reviewed_at": null,
  "employee": {
    "id": 1,
    "name": "Employee 1",
    "email": "employee1@example.com",
    "role": "employee"
  },
  "reviewer": null
}
```

#### Update Expense
```http
PATCH /api/v1/expenses/1
Headers:
  X-User-ID: 1
  Content-Type: application/json

Body:
{
  "expense": {
    "amount": 85.00,
    "description": "Updated team dinner"
  }
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "amount": "85.00",
  "description": "Updated team dinner",
  "state": "drafted",
  "submitted_at": null,
  "reviewed_at": null,
  "employee": {
    "id": 1,
    "name": "Employee 1",
    "email": "employee1@example.com",
    "role": "employee"
  },
  "reviewer": null
}
```

#### Delete Expense
```http
DELETE /api/v1/expenses/1
Headers: X-User-ID: 1
```

**Response (200 OK):**
```json
{
  "id": 1,
  "amount": "85.00",
  "description": "Updated team dinner",
  "state": "drafted",
  "submitted_at": null,
  "reviewed_at": null,
  "employee": {
    "id": 1,
    "name": "Employee 1",
    "email": "employee1@example.com",
    "role": "employee"
  },
  "reviewer": null
}
```

#### Submit Expense
```http
POST /api/v1/expenses/1/submit
Headers: X-User-ID: 1
```

**Response (200 OK):**
```json
{
  "id": 1,
  "amount": "85.00",
  "description": "Updated team dinner",
  "state": "submitted",
  "submitted_at": "2025-10-08T12:00:00.000Z",
  "reviewed_at": null,
  "employee": {
    "id": 1,
    "name": "Employee 1",
    "email": "employee1@example.com",
    "role": "employee"
  },
  "reviewer": null
}
```

#### Approve Expense
```http
POST /api/v1/expenses/1/approve
Headers: X-User-ID: 3
```

**Response (200 OK):**
```json
{
  "id": 1,
  "amount": "85.00",
  "description": "Updated team dinner",
  "state": "approved",
  "submitted_at": "2025-10-08T12:00:00.000Z",
  "reviewed_at": "2025-10-08T13:00:00.000Z",
  "employee": {
    "id": 1,
    "name": "Employee 1",
    "email": "employee1@example.com",
    "role": "employee"
  },
  "reviewer": {
    "id": 3,
    "name": "Reviewer 1",
    "email": "reviewer1@example.com",
    "role": "reviewer"
  }
}
```

#### Reject Expense
```http
POST /api/v1/expenses/1/reject
Headers: X-User-ID: 3
```

**Response (200 OK):**
```json
{
  "id": 1,
  "amount": "85.00",
  "description": "Updated team dinner",
  "state": "rejected",
  "submitted_at": "2025-10-08T12:00:00.000Z",
  "reviewed_at": "2025-10-08T13:00:00.000Z",
  "employee": {
    "id": 1,
    "name": "Employee 1",
    "email": "employee1@example.com",
    "role": "employee"
  },
  "reviewer": {
    "id": 3,
    "name": "Reviewer 1",
    "email": "reviewer1@example.com",
    "role": "reviewer"
  }
}
```

## Error Responses

### 400 Bad Request
```json
{
  "error": "Validation failed: Amount must be greater than 0"
}
```

### 401 Unauthorized
```json
{
  "error": "Unauthorized"
}
```

### 403 Forbidden
```json
{
  "error": "Only employees can create expenses"
}
```

### 404 Not Found
```json
{
  "error": "Expense not found"
}
```

### 422 Unprocessable Entity
```json
{
  "error": "Expense does not belong to the user"
}
```

## Business Rules

### Expense States
- **drafted**: Only visible to creator, can be edited/deleted
- **submitted**: Visible to reviewers, cannot be edited
- **approved**: Final state, cannot be changed
- **rejected**: Final state, cannot be changed

### User Roles
- **employee**: Can create, edit, delete, and submit their own expenses
- **reviewer**: Can approve or reject submitted expenses

### Authorization Rules
- Only employees can create/update/delete expenses
- Only expense owners can edit/delete their own expenses
- Only drafted expenses can be edited or deleted
- Only reviewers can approve/reject expenses
- Only submitted expenses can be approved/rejected

## Development

### Running Tests
```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/services/expense_create_service_spec.rb
```

### Code Quality
```bash
# Run RuboCop
bundle exec rubocop

# Run Brakeman security scanner
bundle exec brakeman
```

## Tech Stack

- **Backend**: Ruby on Rails 8.0.3 (API-only)
- **Database**: PostgreSQL 16.10
- **Serialization**: Active Model Serializers
- **State Management**: AASM (Acts As State Machine)
- **Testing**: RSpec with FactoryBot
