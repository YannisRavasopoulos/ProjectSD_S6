import jwt
import secrets

from datetime import datetime, timezone, timedelta

# TODO
JWT_SECRET = secrets.token_hex(32)
JWT_ALGORITHM = "HS256"

def encode_jwt(payload: dict, hours=2) -> str:
    # Create a token with configurable expiration
    iat = datetime.now(timezone.utc)
    exp = iat + timedelta(hours=hours)

    payload["exp"] = int(exp.timestamp())
    payload["iat"] = int(iat.timestamp())
    token = jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)
    return token

def create_tokens(user_id: int) -> dict:
    # Create both access and refresh tokens
    access_token = encode_jwt({"user_id": user_id}, hours=2)  # Short-lived (2 hours)
    refresh_token = encode_jwt({"user_id": user_id, "refresh": True}, hours=24*7)  # Longer-lived (7 days)
    
    return {
        "access_token": access_token,
        "refresh_token": refresh_token
    }

def decode_jwt(token: str) -> dict:
    try:
        decoded_token = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        return decoded_token
    except jwt.ExpiredSignatureError:
        raise Exception("Token expired")
    except jwt.InvalidTokenError:
        raise Exception("Invalid token")
