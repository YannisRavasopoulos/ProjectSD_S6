from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from middleware.jwt_bearer import JWTBearer
from services.user_service import UserService


router = APIRouter()


class GetUserResponse(BaseModel):
    id: int
    name: str
    email: str


@router.get("/{id}", response_model=GetUserResponse)
async def get_user(id: int, payload=Depends(JWTBearer())):
    user_data = await UserService.get_user(payload["user_id"], id)
    return GetUserResponse(
        id=user_data.id,
        name=user_data.name,
        email=user_data.email
    )


class CreateUserResponse(BaseModel):
    id: int


class CreateUserRequest(BaseModel):
    name: str
    email: str
    password: str


@router.post("/", response_model=CreateUserResponse)
async def create_user(request: CreateUserRequest):
    id = await UserService.create_user(request.name, request.email, request.password)
    return CreateUserResponse(id=id)


class DeleteUserResponse(BaseModel):
    message: str


@router.delete("/{id}", response_model=DeleteUserResponse)
async def delete_user(id: int, payload=Depends(JWTBearer())):
    await UserService.delete_user(payload["user_id"], id)
    return DeleteUserResponse(
        message="User deleted successfully"
    )


class UpdateUserResponse(BaseModel):
    id: int
    name: str
    email: str


class UpdateUserRequest(BaseModel):
    name: str
    email: str
    password: str | None = None


@router.put("/{id}", response_model=UpdateUserResponse)
async def update_user(id: int, request: UpdateUserRequest, payload=Depends(JWTBearer())):
    user_data = await UserService.update_user(payload["user_id"], id, request.name, request.email, request.password)
    return UpdateUserResponse(
        id=user_data.id,
        name=user_data.name,
        email=user_data.email
    )
