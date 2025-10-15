from database import db, User
from utils import encode_jwt
from fastapi import HTTPException, status
from database import db, User
from fastapi import HTTPException, status
import utils 

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

        # Generate both tokens
        tokens = utils.create_tokens(user.id)
        
        # Return just the access token for backward compatibility
        return tokens["access_token"]