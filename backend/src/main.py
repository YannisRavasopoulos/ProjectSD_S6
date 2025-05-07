from fastapi import Depends, FastAPI
from middleware.jwt_bearer import JWTBearer
from routes import auth, users, rides, locations, rewards

app = FastAPI()

# Add tags for grouping endpoints in the OpenAPI documentation.
app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(users.router, prefix="/users", tags=["Users"])
app.include_router(locations.router, prefix="/locations", tags=["Locations"])
app.include_router(rides.router, prefix="/rides", tags=["Rides"])
app.include_router(rewards.router, prefix="/rewards", tags=["Rewards"])

# Protected endpoint requiring JWT authentication.
# Validates the authorization bearer token in the header.
# Returns the decoded token data and a success message.
@app.post("/secure")
def secure_route(payload: dict = Depends(JWTBearer())):
    print(payload)
