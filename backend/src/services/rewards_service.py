from database import db, Reward, UserReward, User
from fastapi import HTTPException, status
from typing import List, Optional

class RewardsService:
    @staticmethod
    async def create_reward(reward_type: str, description: str) -> int:
        """
        Create a new reward in the system
        
        Args:
            reward_type: Type/category of the reward
            description: Detailed description of the reward
            
        Returns:
            ID of the created reward
            
        Raises:
            HTTPException: If database operation fails
        """
        try:
            # Create the reward
            reward = Reward(
                type=reward_type,
                description=description
            )
            
            # Add to database
            db.add(reward)
            db.commit()
            db.refresh(reward)
            
            return reward.id
            
        except Exception as e:
            db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to create reward: {str(e)}"
            )
    
    @staticmethod
    async def get_reward(reward_id: int) -> Reward:
        """
        Get a reward by ID
        
        Args:
            reward_id: ID of the reward to retrieve
            
        Returns:
            Reward object with all details
            
        Raises:
            HTTPException: If reward not found
        """
        reward = db.query(Reward).filter(Reward.id == reward_id).first()
        
        if not reward:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Reward not found"
            )
        
        return reward
    
    @staticmethod
    async def get_all_rewards() -> List[Reward]:
        """
        Get all available rewards
        
        Returns:
            List of all rewards in the system
        """
        return db.query(Reward).all()
    
    @staticmethod
    async def update_reward(reward_id: int, reward_type: Optional[str] = None, description: Optional[str] = None) -> Reward:
        """
        Update a reward's details
        
        Args:
            reward_id: ID of the reward to update
            reward_type: New type for the reward (optional)
            description: New description for the reward (optional)
            
        Returns:
            Updated reward object
            
        Raises:
            HTTPException: If reward not found or update fails
        """
        reward = await RewardsService.get_reward(reward_id)
        
        if reward_type:
            reward.type = reward_type
        
        if description:
            reward.description = description
        
        try:
            db.commit()
            db.refresh(reward)
            return reward
        except Exception as e:
            db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to update reward: {str(e)}"
            )
    
    @staticmethod
    async def delete_reward(reward_id: int) -> None:
        """
        Delete a reward from the system
        
        Args:
            reward_id: ID of the reward to delete
            
        Raises:
            HTTPException: If reward not found or deletion fails
        """
        reward = await RewardsService.get_reward(reward_id)
        
        try:
            db.delete(reward)
            db.commit()
        except Exception as e:
            db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to delete reward: {str(e)}"
            )
    
    @staticmethod
    async def redeem_reward(user_id: int, reward_id: int) -> None:
        """
        Redeem a reward for a user
        
        Args:
            user_id: ID of the user redeeming the reward
            reward_id: ID of the reward being redeemed
            
        Raises:
            HTTPException: If user/reward not found, already redeemed, or operation fails
        """
        # Verify user exists
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        # Verify reward exists
        reward = db.query(Reward).filter(Reward.id == reward_id).first()
        if not reward:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Reward not found"
            )
        
        # Check if user already redeemed this reward
        existing_redemption = db.query(UserReward).filter(
            UserReward.user_id == user_id,
            UserReward.reward_id == reward_id
        ).first()
        
        if existing_redemption:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="User has already redeemed this reward"
            )
        
        # Create the user_reward entry
        try:
            user_reward = UserReward(
                user_id=user_id,
                reward_id=reward_id
            )
            
            db.add(user_reward)
            db.commit()
        except Exception as e:
            db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to redeem reward: {str(e)}"
            )
    
    @staticmethod
    async def get_user_rewards(user_id: int) -> List[Reward]:
        """
        Get all rewards redeemed by a specific user
        
        Args:
            user_id: ID of the user
            
        Returns:
            List of rewards redeemed by the user
            
        Raises:
            HTTPException: If user not found
        """
        # Verify user exists
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        # Get all rewards redeemed by user
        user_rewards = db.query(Reward).join(
            UserReward, UserReward.reward_id == Reward.id
        ).filter(UserReward.user_id == user_id).all()
        
        return user_rewards