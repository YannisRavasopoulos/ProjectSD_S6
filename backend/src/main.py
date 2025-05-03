from fastapi import FastAPI

from routes import auth

app = FastAPI()

# Include /auth routes
app.include_router(auth.router, prefix="/auth")
