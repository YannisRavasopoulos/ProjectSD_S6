class AuthService:
    @staticmethod
    async def login(email: str, password: str) -> str:
        user = await UserRepository.get_user_by_email(email)
        if not user or not verify_password(password, user.hashed_password):
            raise Exception("Invalid credentials")
        return generate_jwt({"user_id": user.id})

    @staticmethod
    async def register(email: str, password: str):
        hashed_password = hash_password(password)
        await UserRepository.create_user(email, hashed_password)
