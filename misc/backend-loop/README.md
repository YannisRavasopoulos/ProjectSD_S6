# Backend API Documentation

A secure and efficient backend service providing JWT-based authentication with FastAPI. This API includes user registration, authentication, and token validation functionality.

---

## File Structure

    backend/
    ├── src/
    │   ├── main.py            # FastAPI application and route definitions
    │   ├── middleware/
    │   │   └── jwt_bearer.py  # Bearer token authentication middleware
    │   ├── routes/
    │   │   └── auth.py        # Authentication routes
    │   ├── utils/
    │   │   └── utils.py   # JWT token generation and validation logic
    ├── requirements.txt       # Python dependencies
    ├── Dockerfile             # Dockerfile for containerizing the app
    ├── docker-compose.yml     # Docker Compose configuration
    └── README.md              # This documentation

---

## Key Features

- User registration (signup) with email and password
- User authentication (signin) with JWT generation
- Secure endpoints with JWT validation
- Password hashing for security
- Token expiration handling
- Containerized PostgreSQL database
- Dockerized application environment

---

## Installation & Setup

### Local Development

1. Set up a virtual environment (recommended):

   ```bash
   python -m venv venv
   source venv/bin/activate
   ```

2. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

3. Run the development server:

   ```bash
   uvicorn main:app --reload
   ```

4. When finished, deactivate the virtual environment:

   ```bash
   deactivate
   ```

---

### Docker Setup (Recommended)

```bash
docker rm loop_python loop_postgres
docker-compose build
docker-compose up
```

## API Endpoints

### Authentication

- `POST /users` - Create a new user

  Request:

  ```json
  {
    "name": "string",
    "email": "string",
    "password": "string"
  }
  ```

- `POST /auth/login` - Authenticate and get JWT token

  Request:

  ```json
  {
    "email": "<email>",
    "password": "<password>"
  }
  ```

  Response:

  ```json
  {
    "token": "<jwt-token>"
  }
  ```

  JWT payload contains:

  ```json
  {
    "user_id": "<id>",
    "iat": 1620000000,
    "exp": 1620000000
  }
  ```

### Protected Routes

- `POST /secure` - Test endpoint requiring valid JWT

  Requires `Authorization: Bearer <token>` header.

---

## Development Workflow

1. Activate virtual environment:

   ```bash
   source venv/bin/activate
   ```

2. Start the development server:

   ```bash
   uvicorn src.main:app --reload
   ```

3. The API will be available at:

   [http://localhost:8000](http://localhost:8000)

4. Access interactive documentation at:

   [http://localhost:8000/docs](http://localhost:8000/docs)

5. When done working:

   ```bash
   deactivate
   ```

---

## Security Notes

- Passwords are hashed before storage
- JWT tokens expire after 2 hours
- Always use HTTPS in production
- The JWT secret should be stored securely (e.g., in environment variables)
