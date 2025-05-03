import time
import jwt
import secrets
import hashlib
from fastapi import HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session
from database import get_db, User  # Import the database session and User model

# Define schemas first
class SignUpSchema(BaseModel):
    name: str
    email: str
    password: str
    role: str  # Default to carpooler if not specified

class SignInSchema(BaseModel):
    email: str
    password: str

# Then the rest of your code
JWT_SECRET = secrets.token_hex(32)
JWT_ALGORITHM = "HS256"
JWT_EXPIRATION = 3600

def sign(email, user_id):
    payload = {
        "email": email,
        "userId": user_id,
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

def signup(name, email, password, role, db: Session = Depends(get_db)):
    hashed_password = hashlib.sha256(password.encode()).hexdigest()
    existing_user = db.query(User).filter(User.email == email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    new_user = User(name=name, email=email, hashed_password=hashed_password, role=role)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    token = sign(new_user.email, new_user.id)
    return token

def signin(email, password, db: Session = Depends(get_db)):
    hashed_password = hashlib.sha256(password.encode()).hexdigest()
    user = db.query(User).filter(User.email == email).first()
    if user:
        if user.hashed_password == hashed_password:
            token = sign(user.email, user.id)
            return token
        else:
            raise HTTPException(status_code=400, detail="Incorrect password")
    raise HTTPException(status_code=400, detail="Email not registered")