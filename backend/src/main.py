from fastapi import FastAPI, Depends, Query, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session
from jwtsign import sign, decode, signup, signin, SignUpSchema, SignInSchema
from jwtvalidate import Bearer
from database import get_db

app = FastAPI()

# Register a new user with name, email, password, and role.
# Creates user in database and returns a JWT token.
@app.post("/signup")
def register_user(
    request: SignUpSchema,
    db: Session = Depends(get_db)
):
    try:
        token = signup(
            name=request.name,
            email=request.email,
            password=request.password,
            role=request.role,
            db=db
        )
        return {"token": token}
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid role specified")

# Authenticate an existing user with email and password.
# Returns a JWT token on successful authentication.
@app.post("/signin")
def authenticate_user(
    request: SignInSchema,
    db: Session = Depends(get_db)
):
    token = signin(
        email=request.email,
        password=request.password,
        db=db
    )
    return {"token": token}


# Protected endpoint requiring JWT authentication.
# Validates the authorization bearer token in the header.
# Returns the decoded token data and a success message.
@app.post("/secure")
def secure_route(token: str = Depends(Bearer())):
    return {"message": "Authenticated successfully", "token_data": decode(token)}

# Debug/testing endpoint to verify JWT token contents.
# Takes a token as a query parameter and returns the decoded payload.
# NOTE: This endpoint is for testing purposes and should be disabled in production.
@app.post("/authtest")
def auth_test(token: str = Query(...)):
    return decode(token)
