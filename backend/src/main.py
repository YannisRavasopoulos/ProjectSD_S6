from fastapi import Depends, FastAPI
from middleware.jwt_bearer import JWTBearer
from routes import auth, users

app = FastAPI()

# Include /auth routes
app.include_router(auth.router, prefix="/auth")

app.include_router(users.router, prefix="/users")

# Protected endpoint requiring JWT authentication.
# Validates the authorization bearer token in the header.
# Returns the decoded token data and a success message.
@app.post("/secure")
def secure_route(payload: dict = Depends(JWTBearer())):
    print(payload)
