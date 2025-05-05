from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel
import utils

from services.auth_service import AuthService

router = APIRouter()


class LoginRequest(BaseModel):
    email: str
    password: str


class LoginResponse(BaseModel):
    token: str
    refresh_token: str = None


class LogoutRequest(BaseModel):
    pass


class LogoutResponse(BaseModel):
    pass


class RefreshRequest(BaseModel):
    refresh_token: str


@router.post("/login", response_model=LoginResponse)
async def login(request: LoginRequest):
    """
    Authenticate an existing user with email and password.
    Returns a JWT token on successful authentication.
    """

    token = await AuthService.login(request.email, request.password)

    # Get both tokens
    user_id = utils.decode_jwt(token).get("user_id")
    tokens = utils.create_tokens(user_id)

    return {
        "token": tokens["access_token"],
        "refresh_token": tokens["refresh_token"]
    }


# Logout the user by invalidating the JWT token.
# TODO
@router.post("/logout", response_model=LogoutResponse)
async def logout(request: LogoutRequest):
    await AuthService.logout()


'''
Client logs in with email/password and gets both an access token and a refresh token
Client uses the access token for API requests
When the access token expires, client calls /auth/refresh with the refresh token
The server returns a new access token
Client continues using the new access token
'''


@router.post("/refresh", response_model=LoginResponse)
async def refresh_token(request: RefreshRequest):
    try:
        # Decode and validate the refresh token
        payload = utils.decode_jwt(request.refresh_token)

        # Check if it's actually a refresh token
        if not payload.get("refresh", False):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid refresh token"
            )

        # Extract user_id from the token
        user_id = payload.get("user_id")
        if not user_id:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid token payload"
            )

        # Generate new tokens (both access and refresh)
        tokens = utils.create_tokens(user_id)

        # Return both tokens
        return {
            "token": tokens["access_token"],
            "refresh_token": tokens["refresh_token"]
        }

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e)
        )
