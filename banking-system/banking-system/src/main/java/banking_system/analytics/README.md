# Banking Customer & Transaction Analysis System

A full-stack banking analytics application built using MySQL, Spring Boot, and React.

## Project Overview

The system manages banking customers, accounts, transactions, branches, account types, and loans.

It provides analytics to understand customer activity, transaction trends, branch performance, and loan exposure.

## Tech Stack

- MySQL
- Java
- Spring Boot
- Spring Data JPA
- REST APIs
- React
- Axios
- Recharts

## Database

The MySQL database contains six main tables:

- Customers
- Branches
- Account Types
- Accounts
- Transactions
- Loans

Relationships include:

Customer → Accounts → Transactions

Customer → Loans

Branch → Accounts

Account Type → Accounts

## Key Features

### Dashboard

Displays:

- Total customers
- Total accounts
- Total balance
- Total transactions
- Total loans
- Outstanding loan amount

Also provides charts for:

- Monthly transaction activity
- Transaction types
- Branch performance
- Loan exposure

### Customer Management

- View customers
- Search customers
- View customer details
- View customer's accounts
- View customer's loans
- View transaction activity

### Account Management

- View all bank accounts
- View balances
- View account status
- View branch and account type information

### Transaction Management

Supports:

- Deposits
- Withdrawals
- Account-to-account transfers
- Transaction history
- Transaction search
- Transaction-type filtering

### Loan Analysis

Displays:

- Loan type
- Loan amount
- Outstanding amount
- Interest rate
- Loan status

## SQL Features

The project demonstrates:

- JOINs
- GROUP BY
- Aggregate functions
- Subqueries
- Views
- Stored procedures
- Triggers
- Transaction handling

Important analytical views include:

- Customer Financial Summary
- Branch Performance
- Monthly Transaction Summary
- Customer Activity Summary

## Backend Architecture

The Spring Boot backend follows a layered structure:

Controller → Service → Repository → MySQL

### Controller

Handles HTTP requests and exposes REST APIs.

### Service

Contains business logic for operations such as deposits, withdrawals, and transfers.

### Repository

Uses Spring Data JPA to communicate with the database.

### Analytics

Uses SQL queries through JPA to generate banking analytics.

## Frontend Architecture

The React frontend communicates with the Spring Boot backend using Axios.

The dashboard uses Recharts for data visualization.

## Example APIs

GET /api/customers

GET /api/accounts

GET /api/transactions

GET /api/loans

GET /api/analytics/summary

GET /api/analytics/top-customers

GET /api/analytics/monthly-transactions

GET /api/analytics/branch-performance

POST /api/transactions/deposit

POST /api/transactions/withdraw

POST /api/transactions/transfer

## How to Run

### 1. Database

Create the MySQL database and execute:

banking_project_final_clean.sql

### 2. Backend

Open the banking-system folder and configure:

spring.datasource.username

spring.datasource.password

Then run:

./mvnw spring-boot:run

The backend runs on:

http://localhost:8080

### 3. Frontend

Open the banking-frontend folder and run:

npm install

npm run dev

The frontend runs on:

http://localhost:5173

## Project Architecture

React Frontend
        |
        | REST API
        v
Spring Boot Backend
        |
        +-- Controllers
        |
        +-- Services
        |
        +-- Repositories
        |
        +-- Analytics
        |
        v
MySQL Database

## Future Improvements

- Authentication and role-based access
- Pagination for large datasets
- Advanced transaction filtering
- Deployment using cloud services
- Automated testing