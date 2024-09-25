from beanie import PydanticObjectId
from fastapi import APIRouter, HTTPException
from typing import List

from seventy_five_you.lib.backend.app.server.models.outside_workout_model import Workout

router = APIRouter()

@router.post("/", response_description="workout added to the database")
async def add_workout(workout: Workout) -> dict:
    await workout.create()
    return {"message": "workout added successfully"}

@router.get("/workout/{firebase_uid}")
async def get_workout(firebase_uid: str):
    workout = await Workout.find_one({"firebase_uid": firebase_uid})
    if workout:
        return workout
    else:
        raise HTTPException(status_code=404, detail="workout not found")
@router.get("/workouts")
async def get_all_workouts() -> List[Workout]: 
    workouts = await Workout.all().to_list()  # Assuming workout model has a `all()` method to retrieve all workouts
    if workouts:
        return workouts
    else:
        raise HTTPException(status_code=404, detail="No workouts found")
@router.put("/workout/{firebase_uid}", response_description="workout updated successfully")
async def update_workout(firebase_uid: str, updated_workout_data: Workout) -> dict:
    workout = await Workout.find_one({"firebase_uid": firebase_uid})
    if workout:
        # Update workout fields with the provided data
        for field, value in updated_workout_data.dict().items():
            setattr(workout, field, value)
        await workout.save()
        return {"message": "workout updated successfully"}
    else:
        raise HTTPException(status_code=404, detail="workout not found")
@router.delete("/workout/{firebase_uid}", response_description="workout deleted from the database")
async def delete_workout(firebase_uid: str) -> dict:
    workout = await Workout.find_one({"firebase_uid": firebase_uid})