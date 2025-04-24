# Library Management System & Task Manager API

## Project Description

This repository contains two assignments:
1. A complete Library Management System database implemented in MySQL
2. A Task Manager CRUD API built with FastAPI (Python) and MySQL

## Question 1: Library Management Database

### Features
- Complete relational database schema for a library
- Tables for members, books, authors, publishers, loans, and fines
- Proper relationships and constraints
- Sample data for demonstration

### How to Import
1. Ensure MySQL is installed and running
2. Execute the entire `library_management.sql`

## Question 2: Task Manager API

### Features
- Complete CRUD operations for users and tasks
- MySQL database integration
- Proper error handling
- RESTful endpoints

## Technologies
- Python 3.9+
- FastAPI
- MySQL
- Uvicorn (ASGI server)

## Setup Instructions
Clone the repository:
```
git clone https://github.com/Nombela95/Database-Management-System

```
## API Endpoints
### Tasks
Method	Endpoint	        Description

GET	   /api/tasks	     Get all tasks
GET	  /api/tasks/:id    Get task by ID
POST	  /api/tasks	     Create new task
PUT	  /api/tasks/:id	  Update task
DELETE	/api/tasks/:id	  Delete task

## How to Run
1. Set up MySQL (run the schema script above).
2. Install dependencies:
```
npm install
```
3. Start the server:
```
node app.js
```
4. Test API using Postman or curl:
```
curl http://localhost:3000/api/tasks
```