# Multi-Tenant Project Backend

## 1. Project Overview
This is a backend service for a multi-tenant B2B application.  
It supports:
- Multi-tenant data isolation
- Role-Based Access Control (RBAC)
- Authentication with JWT
- CRUD operations for projects, tasks, discussion threads, and replies
- Search, filtering, and basic reporting

---

## 2. Tech Stack
- **Language & Framework:** Ruby on Rails (API design)
- **Database:** PostgreSQL
- **Authentication:** JWT
- **Other Gems:** (Devise, Pundit, etc. if used)

---

## 3. Architecture / Project Structure
- Follows MVC pattern
- Core models: Tenant, User, Role, Project, Task, DiscussionThread, Reply
- Controllers handle API requests and enforce RBAC and tenant isolation
- Serializers used for structured JSON responses
- (Optional) Services for complex business logic

---

## 4. Setup and running Instructions

```bash
git clone <repo-url>
cd backend
bundle install
rails db:create
rails db:migrate
rails s
rails db:seed
```
Rails server runs at http://localhost:3000 by default


## Database design & schema

## API endpoints & request/response examples

##  Authentication & RBAC setup

## Any assumptions or notes

## How to run tests, seed data, or script