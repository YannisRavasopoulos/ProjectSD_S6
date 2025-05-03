from fastapi import APIRouter
from sqlalchemy.orm import Session
from fastapi import Depends
from services.auth_service import SignInSchema, signin

from pydantic import BaseModel

# Define schemas first
# class SignUpSchema(BaseModel):
    # name: str
    # email: str
    # password: str
    # role: str  # Default to carpooler if not specified

class LoginSchema(BaseModel):
    email: str
    password: str



router = APIRouter()

# Authenticate an existing user with email and password.
# Returns a JWT token on successful authentication.
@router.post("/login")
async def login():
    pass
    # request: SignInSchema,
    # db: Session = Depends(get_db)
    # try:
    #     token = signin(
    #         email=request.email,
    #         password=request.password,
    #         db=db
    #     )
    #     return {"token": token}


@router.post("/logout")
async def logout():
    pass
