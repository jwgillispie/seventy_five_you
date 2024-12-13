from beanie import PydanticObjectId
from fastapi import APIRouter, HTTPException
from typing import List
from server.models.reminder_model import Reminder

router = APIRouter()
@router.post("/", response_description="reminders added to database")
async def add_reminders(reminders: Reminders) -> dict:
    await reminders.create()
    return {"message": "reminders added successfully"}

@router.get("/reminders/{firebase_uid}")
async def get_reminders(firebase_uid: str):
    reminders = await Reminders.find_one({"firebase_uid": firebase_uid})
    if reminders:
        return reminders
    else:
        raise HTTPException(status_code=404, detail="reminders not found")
@router.get("/reminders")
async def get_all_reminders() -> List[Reminders]: 
    reminders = await Reminders.all().to_list()  # Assuming reminders model has an `all()` method to retrieve all diets
    if reminders:
        return reminders
    else:
        raise HTTPException(status_code=404, detail="No reminders found")
@router.put("/reminders/{firebase_uid}", response_description="reminders updated successfully")
async def update_reminder(firebase_uid: str, updated_reminders_data: Reminders, key_to_update: str) -> dict:
    reminders = await Reminders.find_one({"firebase_uid": firebase_uid})
    if reminders:
        # Update reminders fields with the provided data
        setattr(reminders, key_to_update, reminders[key_to_update])
        await reminders.save()
        return {"message": "reminders updated successfully"}
    else:
        raise HTTPException(status_code=404, detail="reminders not found")
@router.delete("/reminders/{firebase_uid}", response_description="reminders deleted from the database")
async def delete_reminders(firebase_uid: str) -> dict:
    reminders = await Reminders.find_one({"firebase_uid": firebase_uid})
    # if reminders:
    #     reminders.delete()
    # if reminders:
    #     # Update diet fields with the provided data
    #     for field, value in updated_reminders_data.dict().items():
    #         setattr(reminders, field, value)
    #     await reminders.save()
    #     return {"message": "reminders updated successfully"}