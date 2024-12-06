from beanie import Document
from pydantic import EmailStr
from typing import List, Optional
from datetime import datetime
class OutsideWorkout(Document):
    class Settings:
        name = "OutsideWorkout"
    date : str  # Date of the day
    firebase_uid : str
    description : str  # Description of the workout
    thoughts: str  # Thoughts on the workout
    completed: bool
   








