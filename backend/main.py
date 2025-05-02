from fastapi import FastAPI, Depends, Query
from pydantic import BaseModel
from sqlalchemy.orm import Session
from jwtsign import sign, decode, signup, signin, SignUpSchema, SignInSchema
from jwtvalidate import Bearer
from database import get_db

app = FastAPI()

@app.post("/signup")
def register_user(
    request: SignUpSchema,
    db: Session = Depends(get_db)
):
    try:
        token = signup(
            name=request.name,
            email=request.email,
            password=request.password,
            role=request.role,
            db=db
        )
        return {"token": token}
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid role specified")

@app.post("/signin")
def authenticate_user(
    request: SignInSchema,
    db: Session = Depends(get_db)
):
    token = signin(
        email=request.email,
        password=request.password,
        db=db
    )
    return {"token": token}

@app.post("/secure")
def secure_route(token: str = Depends(Bearer())):
    return {"message": "Authenticated successfully", "token_data": decode(token)}

@app.post("/authtest")
def auth_test(token: str = Query(...)):
    return decode(token)
