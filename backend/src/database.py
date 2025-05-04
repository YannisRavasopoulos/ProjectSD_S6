from sqlalchemy import (
    create_engine, Column, Integer, Text, ForeignKey, CheckConstraint, TIMESTAMP, Column, Integer, Text,
    Float, String, DateTime, func, ForeignKey, CheckConstraint
)
from sqlalchemy.dialects.postgresql import JSONB, ENUM
from sqlalchemy.orm import DeclarativeBase, sessionmaker
import enum
import os
import utils

from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class Base(DeclarativeBase):
    __abstract__ = True

# See docker-compose.yml
DATABASE_URL = os.getenv("DATABASE_URL")

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

db = SessionLocal()

# ENUMs
class UserRole(enum.Enum):
    driver = "driver"
    carpooler = "carpooler"

class RideType(enum.Enum):
    instaride = "instaride"
    activity = "activity"


class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False)
    email = Column(String(255), unique=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    @staticmethod
    def _hash_password(password: str) -> str:
        return pwd_context.hash(password)

    @staticmethod
    def _verify_password(plain_password: str, hashed_password: str) -> bool:
        return pwd_context.verify(plain_password, hashed_password)

    def __init__(self, name: str, email: str, password: str):
        self.name = name
        self.email = email
        self.hashed_password = User._hash_password(password)

    def verify_password(self, password: str) -> bool:
        return User._verify_password(password, self.hashed_password)


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
    latitude = Column(Float)  # Stores latitude value
    longitude = Column(Float)  # Stores longitude value

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

# TODO

# Check if admin user already exists
admin_exists = db.query(User).filter(User.email == "admin@loop.app").first()
if not admin_exists:
    admin_user = User(name="admin", email="admin@loop.app", password="admin")
    db.add(admin_user)
    db.commit()
    print("Admin user created")
else:
    print("Admin user already exists")
