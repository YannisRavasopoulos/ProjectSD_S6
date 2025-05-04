import jwt
import secrets

from datetime import datetime, timezone, timedelta

# TODO
JWT_SECRET = secrets.token_hex(32)
JWT_ALGORITHM = "HS256"

def encode_jwt(payload: dict) -> str:
    # TODO: expiration in 2 hours
    iat = datetime.now(timezone.utc)
    exp = iat + timedelta(hours=2)

    payload["exp"] = int(exp.timestamp())
    payload["iat"] = int(iat.timestamp())
    token = jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)
    return token

def decode_jwt(token: str) -> dict:
    try:
        decoded_token = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        return decoded_token
    except jwt.ExpiredSignatureError:
        raise Exception("Token expired")
    except jwt.InvalidTokenError:
        raise Exception("Invalid token")
