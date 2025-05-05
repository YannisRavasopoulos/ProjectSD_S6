from database import db, User
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
        return user.id

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

    @staticmethod
    async def delete_user(actor_id: int, user_id: int) -> None:
        user = await UserService.get_user(actor_id, user_id)
        db.delete(user)
        db.commit()

    @staticmethod
    async def update_user(actor_id: int, user_id: int, name: str, email: str, password: str | None) -> User:
        user = await UserService.get_user(actor_id, user_id)

        if not user.can_have_email(email):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already taken"
            )

        user.name = name
        user.email = email
        if password:
            user.hashed_password = user._hash_password(password)

        db.commit()
        db.refresh(user)
        return user
