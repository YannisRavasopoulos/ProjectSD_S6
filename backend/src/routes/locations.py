from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from middleware.jwt_bearer import JWTBearer
from services.locations_service import LocationsService

router = APIRouter()

# Request Models
class CreateLocationRequest(BaseModel):
    address: str      
    latitude: float  
    longitude: float  

# Response Models
class CreateLocationResponse(BaseModel):
    id: int  

class GetLocationResponse(BaseModel):
    id: int           
    address: str      
    latitude: float   
    longitude: float  

# Create Location
@router.post("/", response_model=CreateLocationResponse)
async def create_location(request: CreateLocationRequest, payload: dict = Depends(JWTBearer())):

    location_id = await LocationsService.create_location(
        address=request.address,
        latitude=request.latitude,
        longitude=request.longitude
    )
    
    return {"id": location_id}

# Get Location
@router.get("/{id}", response_model=GetLocationResponse)
async def get_location(id: int, payload: dict = Depends(JWTBearer())):
  
    location = await LocationsService.get_location(id)
    
    return {
        "id": location.id,
        "address": location.address,
        "latitude": location.latitude,
        "longitude": location.longitude
    }