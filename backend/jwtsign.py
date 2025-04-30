import time
import jwt
import secrets
import hashlib
from fastapi import HTTPException
from pydantic import BaseModel

# Define schemas first
class SignUpSchema(BaseModel):
    name: str
    email: str
    password: str

class SignInSchema(BaseModel):
    email: str
    password: str

# Then the rest of your code
JWT_SECRET = secrets.token_hex(32)
JWT_ALGORITHM = "HS256"
JWT_EXPIRATION = 3600

userlist = []

def sign(email):
    payload = {
        "email": email,
        "exp": time.time() + JWT_EXPIRATION
    }
    token = jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)
    return token

def decode(token):
    try:
        decoded_token = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        return decoded_token
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")

def signup(name, email, password):
    hashed_password = hashlib.sha256(password.encode()).hexdigest()
    for user in userlist:
        if user.email == email:
            raise HTTPException(status_code=400, detail="Email already registered")
    user = SignUpSchema(name=name, email=email, password=hashed_password)
    userlist.append(user)
    token = sign(user.email)
    return token

def signin(email, password):
    hashed_password = hashlib.sha256(password.encode()).hexdigest()
    for user in userlist:
        if user.email == email:
            if user.password == hashed_password:
                token = sign(user.email)
                return token
            else:
                raise HTTPException(status_code=400, detail="Incorrect password")
    raise HTTPException(status_code=400, detail="Email not registered")