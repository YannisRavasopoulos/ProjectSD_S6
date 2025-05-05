from fastapi import Depends, FastAPI
from middleware.jwt_bearer import JWTBearer
from routes import auth, users, rides, locations

app = FastAPI()

# Include /auth routes
app.include_router(auth.router, prefix="/auth", tags=["Authentication"])

# Include /users routes with tag
app.include_router(users.router, prefix="/users", tags=["Users"])

# Include /locations routes with tag
app.include_router(locations.router, prefix="/locations", tags=["Locations"])

# Include /rides routes with tag
app.include_router(rides.router, prefix="/rides", tags=["Rides"])

# Protected endpoint requiring JWT authentication.
# Validates the authorization bearer token in the header.
# Returns the decoded token data and a success message.
@app.post("/secure")
def secure_route(payload: dict = Depends(JWTBearer())):
    print(payload)
