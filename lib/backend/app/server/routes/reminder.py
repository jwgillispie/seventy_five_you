from beanie import PydanticObjectId
from fastapi import APIRouter, HTTPException
from typing import List
from server.models.reminder_model import Reminder

router = APIRouter()
@router.post("/", response_description="Reminder added to database")
async def add_reminder(reminder: Reminder) -> dict:
    await reminder.create()
    return {"message": "reminder added successfully"}

@router.get("/reminder/{firebase_uid}")
async def get_reminder(firebase_uid: str):
    reminder = await Reminder.find_one({"firebase_uid": firebase_uid})
    if reminder:
        return reminder
    else:
        raise HTTPException(status_code=404, detail="reminder not found")
@router.get("/reminder")
async def get_all_reminder() -> List[Reminder]: 
    reminder = await Reminder.all().to_list()  # Assuming reminder model has an `all()` method to retrieve all diets
    if reminder:
        return reminder
    else:
        raise HTTPException(status_code=404, detail="No reminder found")
@router.put("/reminder/{firebase_uid}", response_description="reminder updated successfully")
async def update_reminder(firebase_uid: str, updated_reminder_data: Reminder, key_to_update: str) -> dict:
    reminder = await Reminder.find_one({"firebase_uid": firebase_uid})
    if reminder:
        # Update reminder fields with the provided data
        setattr(reminder, key_to_update, reminder[key_to_update])
        await reminder.save()
        return {"message": "reminder updated successfully"}
    else:
        raise HTTPException(status_code=404, detail="reminder not found")
@router.delete("/reminder/{firebase_uid}", response_description="reminder deleted from the database")
async def delete_reminder(firebase_uid: str) -> dict:
    reminder = await Reminder.find_one({"firebase_uid": firebase_uid})
    # if reminder:
    #     reminder.delete()
    # if reminder:
    #     # Update diet fields with the provided data
    #     for field, value in updated_reminder_data.dict().items():
    #         setattr(reminder, field, value)
    #     await reminder.save()
    #     return {"message": "reminder updated successfully"}