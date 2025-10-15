from database import db, Ride, Location, RideType, RideOffer
from fastapi import HTTPException, status
from datetime import datetime
from typing import Optional

class RidesService:
    @staticmethod
    async def create_ride(
        arrival_time: datetime, 
        destination: str, 
        origin_location_id: int, 
        destination_location_id: int, 
        ride_type: RideType
    ) -> int:
     
        try:
            # Verify that the origin location exists
            origin = db.query(Location).filter(Location.id == origin_location_id).first()
            if not origin:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail=f"Origin location with ID {origin_location_id} not found"
                )
                
            # Verify that the destination location exists
            dest = db.query(Location).filter(Location.id == destination_location_id).first()
            if not dest:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail=f"Destination location with ID {destination_location_id} not found"
                )
            
            # Create the ride
            ride = Ride(
                arrival_time=arrival_time,
                destination=destination,
                origin_location_id=origin_location_id,
                destination_location_id=destination_location_id,
                type=ride_type
            )
            
            # Add to database
            db.add(ride)
            db.commit()
            db.refresh(ride)
            
            return ride.id
            
        except Exception as e:
            db.rollback()
            if isinstance(e, HTTPException):
                raise e
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to create ride: {str(e)}"
            )
    


    @staticmethod
    async def get_ride(ride_id: int) -> Ride:
       
        ride = db.query(Ride).filter(Ride.id == ride_id).first()
        
        if not ride:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Ride not found"
            )
        
        return ride
    



    @staticmethod
    async def create_ride_offer(driver_id: int, ride_id: int) -> None:
        
        # Check if ride exists
        ride = db.query(Ride).filter(Ride.id == ride_id).first()
        if not ride:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Ride not found"
            )
            
        # Check if offer already exists
        existing_offer = db.query(RideOffer).filter(
            RideOffer.driver_id == driver_id,
            RideOffer.ride_id == ride_id
        ).first()
        
        if existing_offer:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Ride offer already exists"
            )
        
        # Create ride offer
        ride_offer = RideOffer(
            driver_id=driver_id,
            ride_id=ride_id
        )
        
        db.add(ride_offer)
        db.commit()