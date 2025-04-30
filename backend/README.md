# Backend API Documentation

A secure and efficient backend service providing JWT-based authentication with FastAPI. This API includes user registration, authentication, and token validation functionality.

## File Structure

    backend/
    ├── main.py            # FastAPI application and route definitions
    ├── jwtsign.py         # JWT token generation and validation logic
    ├── jwtvalidate.py     # Bearer token authentication middleware
    ├── requirements.txt   # Python dependencies
    └── README.md          # This documentation

## Key Features

- User registration (signup) with email and password
  `pip install -r requirements.txtuvicorn main:app --reload`
- User authentication (signin) with JWT generation
- Secure endpoints with JWT validation
- Password hashing for security
- Token expiration handling

## Installation & Setup

1. Clone the repository (if you haven't already)

    ```bash
    git clone <repository-url>
    cd backend
    ```

2. Set up a virtual environment (recommended)

    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows use: venv\Scripts\activate
    ```

3. Install dependencies

    ```bash
    pip install -r requirements.txt
    ```

4. Run the development server

    ```bash
    uvicorn main:app --reload
    ```

5. When finished, deactivate the virtual environment

    ```bash
    deactivate
    ```

## API Endpoints

### Authentication

- `POST /signup` - Register a new user

    ```json
    {
      "name": "string",
      "email": "string",
      "password": "string"
    }
    ```

- `POST /signin` - Authenticate and get JWT token

    ```json
    {
      "email": "string",
      "password": "string"
    }
    ```

### Protected Routes

- `POST /secure` - Test endpoint requiring valid JWT

    Requires Authorization: Bearer <token> header

## Development Workflow

1. Activate virtual environment:

    ```bash
    source venv/bin/activate
    ```

2. Start the development server:

    ```bash
    uvicorn main:app --reload
    ```

3. The API will be available at:

    http://localhost:8000

4. Access interactive documentation at:

    http://localhost:8000/docs

5. When done working:

    ```bash
    deactivate
    ```

## Dependencies

- Python 3.7+
- FastAPI
- PyJWT
- Uvicorn

All dependencies are listed in requirements.txt and will be installed automatically with `pip install -r requirements.txt`.

## Security Notes

- Passwords are hashed before storage
- JWT tokens expire after 1 hour
- Always use HTTPS in production
- The JWT secret is randomly generated on each startup (for development)