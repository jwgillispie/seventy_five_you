from fastapi import APIRouter, HTTPException, Body
from server.models.day_model import Day  # Import your Day model
from typing import List
from datetime import date

router = APIRouter()

@router.post("/", response_description="Day added to the database")
async def add_day(day: Day) -> dict:
    await day.create()
    return {"message": "Day added successfully"}

@router.get("/day/{firebase_uid}", response_model=Day)
async def get_day_by_firebase_uid(firebase_uid: str) -> Day:
    day = await Day.find_one({"firebase_uid": firebase_uid})
    if day:
        return day
    else:
        raise HTTPException(status_code=404, detail="Day not found")

@router.put("/day/{firebase_uid}", response_model=Day)
async def update_day_by_firebase_uid(firebase_uid: str, updated_fields: dict) -> Day:
    day = await Day.find_one({"firebase_uid": firebase_uid})
    if day:
        for key, value in updated_fields.items():
            setattr(day, key, value)
        await day.save()
        return day
    else:
        raise HTTPException(status_code=404, detail="Day not found")

@router.delete("/day/{firebase_uid}", response_description="Day deleted from the database")
async def delete_day(firebase_uid: str) -> dict:
    day = await Day.find_one({"firebase_uid": firebase_uid})
    if day:
        await day.delete()
        return {"message": "Day deleted successfully"}
    else:
        raise HTTPException(status_code=404, detail="Day not found")

# New endpoint to retrieve a specific day by firebase_uid and date
@router.get("/day/{firebase_uid}/{date}", response_model=Day)
async def get_day_by_firebase_uid_and_date(firebase_uid: str, date: str) -> Day:
    # Parse the date string into a date object
    try:
        parsed_date = date.fromisoformat(date) # Expecting 'YYYY-MM-DD' format
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD.")

    day = await Day.find_one({"firebase_uid": firebase_uid, "date": parsed_date})
    if day:
        return day
    else:
        raise HTTPException(status_code=404, detail="Day not found")

# Add a new route to retrieve all days associated with a particular user ID
@router.get("/days/{firebase_uid}", response_model=List[Day])
async def get_days_by_firebase_uid(firebase_uid: str) -> List[Day]:
    days = await Day.find({"firebase_uid": firebase_uid}).to_list(length=None)
    return days

@router.patch("/day/{firebase_uid}", response_model=Day)
async def patch_day_by_firebase_uid(firebase_uid: str, updated_fields: dict = Body(...)) -> Day:
    day = await Day.find_one({"firebase_uid": firebase_uid})
    if day:
        day_data = day.dict()
        updated_day_data = {**day_data, **updated_fields}
        await day.set(updated_day_data).save()
        return day
    else:
        raise HTTPException(status_code=404, detail="Day not found")
