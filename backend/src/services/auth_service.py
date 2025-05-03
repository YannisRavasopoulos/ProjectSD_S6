# from database import db, User
from utils import encode_jwt

class AuthService:
    @staticmethod
    async def login(email: str, password: str) -> str:

        # user = db.query(User).filter(User.email == email).first()

        if not user:
            raise Exception("User not found")

        if not user.verify_password(password):
            raise Exception("Invalid password")

        token = encode_jwt({"user_id": user.id})
        return token
