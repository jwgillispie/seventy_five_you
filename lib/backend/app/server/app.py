from fastapi import FastAPI, HTTPException
from server.database import init_db
from server.routes.user import router as UserRouter
from server.routes.day import router as DayRouter

app = FastAPI()
app.include_router(UserRouter, tags=["User"], prefix="/user")
app.include_router(DayRouter, tags=["Day"], prefix="/day")

from server.models.user_model import User
from server.models.day_model import Day


@app.on_event("startup")
async def start_db():
    await init_db()


@app.get("/", tags=["Root"])
async def read_root() -> dict:
    return {"message": "Welcome to your beanie powered app!"}


@app.get("/user/{firebase_uid}", response_model=User, tags=["User"])
async def get_user_by_firebase_uid(firebase_uid: str):
    user = await User.find_one({"firebase_uid": firebase_uid})
    if user:
        return user
    else:
        raise HTTPException(status_code=404, detail="User not found")


@app.put("/user/{firebase_uid}", response_model=User, tags=["User"])
async def update_user_by_firebase_uid(firebase_uid: str, updated_fields: dict):
    user = await User.find_one({"firebase_uid": firebase_uid})
    if user:
        for key, value in updated_fields.items():
            setattr(user, key, value)
        await user.save()
        return user
    else:
        raise HTTPException(status_code=404, detail="User not found")


@app.get("/day/{firebase_uid}", response_model=Day, tags=["Day"])
async def get_day_by_firebase_uid(firebase_uid: str):
    day = await Day.find_one({"firebase_uid": firebase_uid})
    if day:
        return day
    else:
        raise HTTPException(status_code=404, detail="Day not found")


@app.put("/day/{firebase_uid}", response_model=Day, tags=["Day"])
async def update_day_by_firebase_uid(firebase_uid: str, updated_fields: dict):
    day = await Day.find_one({"firebase_uid": firebase_uid})
    if day:
        for key, value in updated_fields.items():
            setattr(day, key, value)
        await day.save()
        return day
    else:
        raise HTTPException(status_code=404, detail="Day not found")


@app.get("/day/{firebase_uid}/{date}", response_model=Day, tags=["Day"])
async def get_day_by_firebase_uid_and_date(firebase_uid: str, date: str) -> Day:
    print("Searching for day with date")
    day = await Day.find_one({"firebase_uid": firebase_uid, "date": date})
    if day:
        return day
    else:
        raise HTTPException(status_code=404, detail="Day not found")


# New route to update Day by firebase_uid and date
@app.put("/day/{firebase_uid}/{date}", response_model=Day, tags=["Day"])
async def update_day_by_firebase_uid_and_date(firebase_uid: str, date: str, updated_fields: dict):
    print(f"Updating day for user: {firebase_uid} and date: {date}")
    day = await Day.find_one({"firebase_uid": firebase_uid, "date": date})
    if day:
        # Update the fields dynamically
        for key, value in updated_fields.items():
            setattr(day, key, value)
        await day.save()
        return day
    else:
        raise HTTPException(status_code=404, detail="Day not found")
from server.models.outside_workout_model import OutsideWorkout
