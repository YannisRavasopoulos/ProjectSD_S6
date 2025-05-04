from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from middleware.jwt_bearer import JWTBearer
from services.user_service import UserService


class GetUserResponse(BaseModel):
    id: int
    name: str
    email: str


class CreateUserRequest(BaseModel):
    name: str
    email: str
    password: str


class CreateUserResponse(BaseModel):
    id: int


router = APIRouter()

@router.get("/{id}", response_model=GetUserResponse)
async def get_user(id: int, payload = Depends(JWTBearer())):
    user_data = await UserService.get_user(payload["user_id"], id)
    return {
        "id": user_data.id,
        "name": user_data.name,
        "email": user_data.email
    }

@router.post("/", response_model=CreateUserResponse)
async def create_user(request: CreateUserRequest):
    id = await UserService.create_user(request.name, request.email, request.password)
    return {
        "id": id
    }
