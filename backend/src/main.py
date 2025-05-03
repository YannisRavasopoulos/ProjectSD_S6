from fastapi import Depends, FastAPI

from routes import auth

from fastapi import Request, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import utils

class Bearer(HTTPBearer):
    def __init__(self, auto_error: bool = True):
        super().__init__(auto_error=auto_error)

    def validate(self, jwtoken: str):
        try:
            payload = utils.decode_jwt(jwtoken)
            return True
        except:
            return False

    async def __call__(self, request: Request):
        credentials: HTTPAuthorizationCredentials = await super().__call__(request)

        if not credentials:
            raise HTTPException(status_code=403, detail="Invalid authorization code.")

        if credentials.scheme != "Bearer":
            raise HTTPException(status_code=403, detail="Invalid authentication scheme.")

        if not self.validate(credentials.credentials):
            raise HTTPException(status_code=403, detail="Invalid token or expired token.")

        return credentials.credentials


import utils

app = FastAPI()

# Include /auth routes
app.include_router(auth.router, prefix="/auth")

# Protected endpoint requiring JWT authentication.
# Validates the authorization bearer token in the header.
# Returns the decoded token data and a success message.
@app.post("/secure")
def secure_route(token: str = Depends(Bearer())):
    return {"message": "Authenticated successfully", "token_data": utils.decode_jwt(token)}
