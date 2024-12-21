from fastapi import APIRouter, HTTPException, Body
from server.models.challenge_model import Challenge  # Import your Challenge model
from typing import List
from datetime import date

router = APIRouter()

@router.post("/", response_description="Challenge added to the database")
async def add_challenge(challenge: Challenge) -> dict:
    print("Attempting to add challenge")
    await challenge.create()
    print("Challenge added successfully")
    return challenge


@router.get("/{firebase_uid}", response_model=Challenge)
async def get_challenge_by_firebase_uid(firebase_uid: str) -> Challenge:
    challenge = await Challenge.find_one({"firebase_uid": firebase_uid})
    if challenge:
        return challenge
    else:
        raise HTTPException(status_code=404, detail="Challenge not found")

@router.put("/{firebase_uid}", response_model=Challenge)
async def update_challenge_by_firebase_uid(firebase_uid: str, updated_fields: dict) -> Challenge:
    challenge = await challenge.find_one({"firebase_uid": firebase_uid})
    if challenge:
        for key, value in updated_fields.items():
            setattr(challenge, key, value)
        await challenge.save()
        return challenge
    else:
        raise HTTPException(status_code=404, detail="Challenge not found")

@router.delete("/{firebase_uid}", response_description="Challenge deleted from the database")
async def delete_challenge(firebase_uid: str) -> dict:
    challenge = await Challenge.find_one({"firebase_uid": firebase_uid})
    if challenge:
        await challenge.delete()
        return {"message": "Challenge deleted successfully"}
    else:
        raise HTTPException(status_code=404, detail="Challenge not found")

# New endpoint to retrieve a specific challenge by firebase_uid and date
@router.get("/{firebase_uid}/{start_date}", response_model=Challenge)
async def get_challenge_by_firebase_uid_and_date(firebase_uid: str, start_date: str) -> Challenge:
    # Parse the date string into a date object
    try:
        parsed_date = date.fromisoformat(start_date) # Expecting 'YYYY-MM-DD' format
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD.")

    challenge = await Challenge.find_one({"firebase_uid": firebase_uid, "start_date": parsed_date})
    if challenge:
        return challenge
    else:
        raise HTTPException(status_code=404, detail="Challenge not found")

# # Add a new route to retrieve all challenges associated with a particular user ID
# @router.get("/challenges/{firebase_uid}", response_model=List[Challenge])
# async def get_challenges_by_firebase_uid(firebase_uid: str) -> List[Challenge]:
#     challenges = await Challenge.find({"firebase_uid": firebase_uid}).to_list(length=None)
#     return challenges

@router.patch("/{firebase_uid}", response_model=Challenge)
async def patch_challenge_by_firebase_uid(firebase_uid: str, updated_fields: dict = Body(...)) -> Challenge:
    challenge = await Challenge.find_one({"firebase_uid": firebase_uid})
    if challenge:
        challenge_data = challenge.dict()
        updated_challenge_data = {**challenge_data, **updated_fields}
        await challengey.set(updated_challenge_data).save()
        return challenge
    else:
        raise HTTPException(status_code=404, detail="Challenge not found")

