from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from middleware.jwt_bearer import JWTBearer
from services.rewards_service import RewardsService
from typing import List, Optional

router = APIRouter()

# Request Models
class CreateRewardRequest(BaseModel):
    type: str         
    description: str   

class UpdateRewardRequest(BaseModel):
    type: Optional[str] = None         
    description: Optional[str] = None  

class RedeemRewardRequest(BaseModel):
    reward_id: int     

# Response Models
class RewardResponse(BaseModel):
    id: int
    type: str
    description: str

class CreateRewardResponse(BaseModel):
    id: int

class MessageResponse(BaseModel):
    message: str

# Create Reward
@router.post("/", response_model=CreateRewardResponse)
async def create_reward(request: CreateRewardRequest, payload: dict = Depends(JWTBearer())):
    """
    Create a new reward in the system
    
    This endpoint allows administrators to create new rewards that users can redeem.
    Requires authentication.
    """
    reward_id = await RewardsService.create_reward(
        reward_type=request.type,
        description=request.description
    )
    
    return {"id": reward_id}

# Get Reward
@router.get("/{reward_id}", response_model=RewardResponse)
async def get_reward(reward_id: int, payload: dict = Depends(JWTBearer())):
    """
    Get details of a specific reward
    
    This endpoint retrieves information about a specific reward by its ID.
    Requires authentication.
    """
    reward = await RewardsService.get_reward(reward_id)
    
    return {
        "id": reward.id,
        "type": reward.type,
        "description": reward.description
    }

# Get All Rewards
@router.get("/", response_model=List[RewardResponse])
async def get_all_rewards(payload: dict = Depends(JWTBearer())):
    """
    Get all available rewards
    
    This endpoint retrieves all rewards available in the system.
    Requires authentication.
    """
    rewards = await RewardsService.get_all_rewards()
    
    return [
        {
            "id": reward.id,
            "type": reward.type,
            "description": reward.description
        }
        for reward in rewards
    ]

# Update Reward
@router.put("/{reward_id}", response_model=RewardResponse)
async def update_reward(reward_id: int, request: UpdateRewardRequest, payload: dict = Depends(JWTBearer())):
    """
    Update details of an existing reward
    
    This endpoint allows administrators to modify reward information.
    Requires authentication.
    """
    updated_reward = await RewardsService.update_reward(
        reward_id=reward_id,
        reward_type=request.type,
        description=request.description
    )
    
    return {
        "id": updated_reward.id,
        "type": updated_reward.type,
        "description": updated_reward.description
    }

# Delete Reward
@router.delete("/{reward_id}", response_model=MessageResponse)
async def delete_reward(reward_id: int, payload: dict = Depends(JWTBearer())):
    """
    Delete a reward from the system
    
    This endpoint allows administrators to remove rewards from the system.
    Requires authentication.
    """
    await RewardsService.delete_reward(reward_id)
    
    return {"message": "Reward deleted successfully"}

# User Rewards

# Redeem Reward
@router.post("/redeem", response_model=MessageResponse)
async def redeem_reward(request: RedeemRewardRequest, payload: dict = Depends(JWTBearer())):
    """
    Redeem a reward for the authenticated user
    
    This endpoint allows users to redeem available rewards.
    The user ID is extracted from the authentication token.
    """
    user_id = payload.get("user_id")
    await RewardsService.redeem_reward(user_id, request.reward_id)
    
    return {"message": "Reward redeemed successfully"}

# Get User Rewards
@router.get("/user/rewards", response_model=List[RewardResponse])
async def get_user_rewards(payload: dict = Depends(JWTBearer())):
    """
    Get all rewards redeemed by the authenticated user
    
    This endpoint retrieves all rewards that the current user has redeemed.
    The user ID is extracted from the authentication token.
    """
    user_id = payload.get("user_id")
    user_rewards = await RewardsService.get_user_rewards(user_id)
    
    return [
        {
            "id": reward.id,
            "type": reward.type,
            "description": reward.description
        }
        for reward in user_rewards
    ]

# Get Other User's Rewards (Admin only)
@router.get("/user/{user_id}/rewards", response_model=List[RewardResponse])
async def get_specific_user_rewards(user_id: int, payload: dict = Depends(JWTBearer())):
    """
    Get all rewards redeemed by a specific user
    
    This endpoint allows administrators to view rewards redeemed by any user.
    Requires authentication with administrative privileges.
    """
    user_rewards = await RewardsService.get_user_rewards(user_id)
    
    return [
        {
            "id": reward.id,
            "type": reward.type,
            "description": reward.description
        }
        for reward in user_rewards
    ]