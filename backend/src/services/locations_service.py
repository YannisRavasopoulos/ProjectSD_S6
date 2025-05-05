from database import db, Location
from fastapi import HTTPException, status

class LocationsService:
    @staticmethod
    async def create_location(address: str, latitude: float, longitude: float) -> int:
        """
        Create a new location in the database
        """
        try:
            # Basic validation
            if latitude < -90 or latitude > 90:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Latitude must be between -90 and 90"
                )
            
            if longitude < -180 or longitude > 180:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Longitude must be between -180 and 180"
                )
            
            # Create the location
            location = Location(
                address=address,
                latitude=latitude,
                longitude=longitude
            )
            
            # Add to database
            db.add(location)
            db.commit()
            db.refresh(location)
            
            return location.id
            
        except Exception as e:
            db.rollback()
            if isinstance(e, HTTPException):
                raise e
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to create location: {str(e)}"
            )
    
    @staticmethod
    async def get_location(location_id: int) -> Location:
        """
        Get a location by ID
        """
        location = db.query(Location).filter(Location.id == location_id).first()
        
        if not location:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Location not found"
            )
        
        return location