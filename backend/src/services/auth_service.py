from database import db, User
from utils import encode_jwt
from fastapi import HTTPException, status

class AuthService:
    @staticmethod
    async def login(email: str, password: str) -> str:
        user = db.query(User).filter(User.email == email).first()

        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )

        if not user.verify_password(password):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid password"
            )

        token = encode_jwt({"user_id": user.id})
        return token
