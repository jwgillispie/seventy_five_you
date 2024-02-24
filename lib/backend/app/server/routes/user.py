from beanie import PydanticObjectId
from fastapi import APIRouter, HTTPException
from typing import List

from server.models.user_model import User


router = APIRouter()

@router.post("/", response_description="User added to the database")
async def add_user(user: User) -> dict:
    await user.create()
    return {"message": "User added successfully"}


@router.get("/user/{firebase_uid}")
async def get_user(firebase_uid: str):
    user = await User.find_one({"firebase_uid": firebase_uid})
    if user:
        return user
    else:
        raise HTTPException(status_code=404, detail="User not found")
@router.get("/users")
async def get_all_users() -> List[User]: 
    users = await User.all().to_list()  # Assuming User model has a `all()` method to retrieve all users
    if users:
        return users
    else:
        raise HTTPException(status_code=404, detail="No users found")
@router.put("/user/{firebase_uid}", response_description="User updated successfully")
async def update_user(firebase_uid: str, updated_user_data: User) -> dict:
    user = await User.find_one({"firebase_uid": firebase_uid})
    if user:
        # Update user fields with the provided data
        for field, value in updated_user_data.dict().items():
            setattr(user, field, value)
        await user.save()
        return {"message": "User updated successfully"}
    else:
        raise HTTPException(status_code=404, detail="User not found")
@router.delete("/user/{firebase_uid}", response_description="User deleted from the database")
async def delete_user(firebase_uid: str) -> dict:
    user = await User.find_one({"firebase_uid": firebase_uid})