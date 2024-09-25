from beanie import PydanticObjectId
from fastapi import APIRouter, HTTPException
from typing import List

from server.models.diet_model import Diet

router = APIRouter()

@router.post("/", response_description="diet added to the database")
async def add_diet(diet: Diet) -> dict:
    await diet.create()
    return {"message": "diet added successfully"}

@router.get("/diet/{firebase_uid}")
async def get_diet(firebase_uid: str):
    diet = await Diet.find_one({"firebase_uid": firebase_uid})
    if diet:
        return diet
    else:
        raise HTTPException(status_code=404, detail="diet not found")
@router.get("/diets")
async def get_all_diets() -> List[Diet]: 
    diets = await Diet.all().to_list()  # Assuming diet model has a `all()` method to retrieve all diets
    if diets:
        return diets
    else:
        raise HTTPException(status_code=404, detail="No diets found")
@router.put("/diet/{firebase_uid}", response_description="diet updated successfully")
async def update_diet(firebase_uid: str, updated_diet_data: Diet) -> dict:
    diet = await Diet.find_one({"firebase_uid": firebase_uid})
    if diet:
        # Update diet fields with the provided data
        for field, value in updated_diet_data.dict().items():
            setattr(diet, field, value)
        await diet.save()
        return {"message": "diet updated successfully"}
    else:
        raise HTTPException(status_code=404, detail="diet not found")
@router.delete("/diet/{firebase_uid}", response_description="diet deleted from the database")
async def delete_diet(firebase_uid: str) -> dict:
    diet = await Diet.find_one({"firebase_uid": firebase_uid})