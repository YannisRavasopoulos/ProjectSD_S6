from fastapi import APIRouter
from sqlalchemy.orm import Session

router = APIRouter()

# Authenticate an existing user with email and password.
# Returns a JWT token on successful authentication.
@router.post("/login")
async def login():
    pass
    # request: SignInSchema,
    # db: Session = Depends(get_db)
    # try:
    #     token = signin(
    #         email=request.email,
    #         password=request.password,
    #         db=db
    #     )
    #     return {"token": token}


@router.post("/logout")
async def logout():
    pass
