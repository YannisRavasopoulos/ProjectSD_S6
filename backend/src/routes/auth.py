from fastapi import APIRouter

from services.auth import AuthService
from schemas.auth import LoginResponse, LoginRequest

router = APIRouter()

# Authenticate an existing user with email and password.
# Returns a JWT token on successful authentication.
@router.post("/login", response_model=LoginResponse)
async def login(request: LoginRequest):
    try:
        token = await AuthService.login(request.email, request.password)
        return {
            "token": token
        }
    except Exception as e:
        # TODO: proper exception handling
        pass

@router.post("/logout")
async def logout():
    pass
