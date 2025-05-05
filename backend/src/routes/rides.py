from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from middleware.jwt_bearer import JWTBearer
from services.rides_service import RidesService
from database import RideType
from datetime import datetime
from typing import Optional

router = APIRouter()

# Request Models
class CreateRideRequest(BaseModel):
    arrival_time: datetime            # When the ride should arrive at destination
    destination: str                  # Text description of the destination
    origin_location_id: int           # ID of the pickup location
    destination_location_id: int      # ID of the dropoff location
    type: str                         # Ride type: "instaride" or "activity"

# Response Models
class CreateRideResponse(BaseModel):
    id: int                           # ID of the created ride

class GetRideResponse(BaseModel):
    id: int                           # ID of the ride
    arrival_time: datetime            # When the ride should arrive at destination
    destination: str                  # Text description of the destination
    origin_location_id: int           # ID of the pickup location
    destination_location_id: int      # ID of the dropoff location
    type: str                         # Ride type: "instaride" or "activity"

# Create Ride
@router.post("/", response_model=CreateRideResponse)
async def create_ride(request: CreateRideRequest, payload: dict = Depends(JWTBearer())):
    try:
        # Convert string type to enum
        ride_type = RideType(request.type)
        
        # Create the ride
        ride_id = await RidesService.create_ride(
            arrival_time=request.arrival_time,
            destination=request.destination,
            origin_location_id=request.origin_location_id,
            destination_location_id=request.destination_location_id,
            ride_type=ride_type
        )
        
        return {"id": ride_id}
    
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid ride type. Must be 'instaride' or 'activity'."
        )

# Get Ride
@router.get("/{id}", response_model=GetRideResponse)
async def get_ride(id: int, payload: dict = Depends(JWTBearer())):

    ride = await RidesService.get_ride(id)
    
    return {
        "id": ride.id,
        "arrival_time": ride.arrival_time,
        "destination": ride.destination,
        "origin_location_id": ride.origin_location_id,
        "destination_location_id": ride.destination_location_id,
        "type": ride.type.value
    }

# Create ride offer - allows a driver to offer a ride
@router.post("/offer", response_model=dict)
async def create_ride_offer(ride_id: int, payload: dict = Depends(JWTBearer())):
 
    driver_id = payload.get("user_id")
    await RidesService.create_ride_offer(driver_id, ride_id)
    
    return {"message": "Ride offer created successfully"}