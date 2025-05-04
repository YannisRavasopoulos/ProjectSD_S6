from database import db, User
from utils import encode_jwt
from fastapi import HTTPException, status

class UserService:
    @staticmethod
    async def create_user(name: str, email: str, password: str) -> int:
        # Check if the user already exists
        existing_user = db.query(User).filter(User.email == email).first()
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="User already exists"
            )

        user = User(name=name, email=email, password=password)
        db.add(user)
        db.commit()
        db.refresh(user)
        token = encode_jwt({"userId": user.id})
        return token

    @staticmethod
    async def get_user(actor_id, user_id: int) -> User:
        if actor_id != user_id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You do not have permission to access this resource"
            )

        user = db.query(User).filter(User.id == user_id).first()

        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )

        return user
