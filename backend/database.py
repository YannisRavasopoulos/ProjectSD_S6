import os
from sqlalchemy import (
    create_engine, Column, Integer, String, Text, ForeignKey, UniqueConstraint,
    CheckConstraint, Enum, JSON, TIMESTAMP, Table
)
from sqlalchemy.dialects.postgresql import JSONB, ENUM
import enum
from sqlalchemy.orm import declarative_base, sessionmaker
from sqlalchemy.exc import SQLAlchemyError


Base = declarative_base()

# ENUMs
class UserRole(enum.Enum):
    driver = "driver"
    carpooler = "carpooler"

class RideType(enum.Enum):
    instaride = "instaride"
    activity = "activity"

# Database connection
SQLALCHEMY_DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://loop_app:kostasaggelos@localhost:5432/loop_app")
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# USERS (Updated with authentication fields)
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False)
    email = Column(String(255), unique=True, nullable=False)  # Added email
    hashed_password = Column(String(255), nullable=False)  # Added password
    role = Column(ENUM(UserRole, name="user_role"), nullable=True, default="carpooler")  # Role is now optional

# VEHICLES
class Vehicle(Base):
    __tablename__ = "vehicles"
    id = Column(Integer, primary_key=True)
    driver_id = Column(Integer, ForeignKey("users.id"), unique=True, nullable=False)
    model = Column(Text, nullable=False)
    license_plate = Column(Text, unique=True, nullable=False)
    capacity = Column(Integer, CheckConstraint("capacity > 0"), nullable=False)

# LOCATIONS
class Location(Base):
    __tablename__ = "locations"
    id = Column(Integer, primary_key=True)
    address = Column(Text)
    #coordinates = Column(Geography("POINT", srid=4326))  # Use Geography from geoalchemy2

# ROUTES
class Route(Base):
    __tablename__ = "routes"
    id = Column(Integer, primary_key=True)
    road_graph = Column(JSONB, nullable=False)
    driver_id = Column(Integer, ForeignKey("users.id"), nullable=False)

# RIDES
class Ride(Base):
    __tablename__ = "rides"
    id = Column(Integer, primary_key=True)
    arrival_time = Column(TIMESTAMP)
    destination = Column(Text)
    origin_location_id = Column(Integer, ForeignKey("locations.id"))
    destination_location_id = Column(Integer, ForeignKey("locations.id"))
    type = Column(ENUM(RideType, name="ride_type"), nullable=False)

# RIDE_OFFERS
class RideOffer(Base):
    __tablename__ = "ride_offers"
    driver_id = Column(Integer, ForeignKey("users.id"), primary_key=True)
    ride_id = Column(Integer, ForeignKey("rides.id"), primary_key=True)

# RIDE_REQUESTS
class RideRequest(Base):
    __tablename__ = "ride_requests"
    carpooler_id = Column(Integer, ForeignKey("users.id"), primary_key=True)
    ride_id = Column(Integer, ForeignKey("rides.id"), primary_key=True)

# PICKUPS
class Pickup(Base):
    __tablename__ = "pickups"
    id = Column(Integer, primary_key=True)
    location_id = Column(Integer, ForeignKey("locations.id"))
    time = Column(TIMESTAMP, nullable=False)
    driver_id = Column(Integer, ForeignKey("users.id"))
    carpooler_id = Column(Integer, ForeignKey("users.id"))

# RATINGS
class Rating(Base):
    __tablename__ = "ratings"
    id = Column(Integer, primary_key=True)
    rater_id = Column(Integer, ForeignKey("users.id"))
    ratee_id = Column(Integer, ForeignKey("users.id"))
    stars = Column(Integer, CheckConstraint("stars BETWEEN 1 AND 5"))
    comment = Column(Text)

# REPORTS
class Report(Base):
    __tablename__ = "reports"
    id = Column(Integer, primary_key=True)
    reporter_id = Column(Integer, ForeignKey("users.id"))
    reported_id = Column(Integer, ForeignKey("users.id"))
    reason = Column(Text, nullable=False)
    description = Column(Text)

# REWARDS
class Reward(Base):
    __tablename__ = "rewards"
    id = Column(Integer, primary_key=True)
    type = Column(Text)
    description = Column(Text)

# USER_REWARDS
class UserReward(Base):
    __tablename__ = "user_rewards"
    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True)
    reward_id = Column(Integer, ForeignKey("rewards.id"), primary_key=True)

# ACTIVITIES
class Activity(Base):
    __tablename__ = "activities"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    description = Column(Text)
    scheduled_time = Column(TIMESTAMP)

# ACTIVITY_RIDES
class ActivityRide(Base):
    __tablename__ = "activity_rides"
    activity_id = Column(Integer, ForeignKey("activities.id"), primary_key=True)
    ride_id = Column(Integer, ForeignKey("rides.id"), primary_key=True)


Base.metadata.create_all(bind=engine)