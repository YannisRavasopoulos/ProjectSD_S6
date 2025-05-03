from fastapi import APIRouter
from pydantic import BaseModel

from services.auth_service import AuthService

router = APIRouter()

class LoginRequest(BaseModel):
    email: str
    password: str

class LoginResponse(BaseModel):
    token: str

class LogoutRequest(BaseModel):
    pass

class LogoutResponse(BaseModel):
    pass

# Authenticate an existing user with email and password.
# Returns a JWT token on successful authentication.
@router.post("/login", response_model=LoginResponse)
async def login(request: LoginRequest):
    token = await AuthService.login(request.email, request.password)
    return {
        "token": token
    }

# Logout the user by invalidating the JWT token.
# TODO
@router.post("/logout", response_model=LogoutResponse)
async def logout(request: LogoutRequest):
    await AuthService.logout()
