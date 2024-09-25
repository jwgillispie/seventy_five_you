from beanie import Document
from pydantic import EmailStr
from typing import List, Optional
from datetime import datetime
from .diet_model import Diet
from .water_model import Water
from .alcohol_model import Alcohol
from .ten_pages_model import TenPages
from .inside_workout_model import InsideWorkout
from .outside_workout_model import OutsideWorkout
class Day(Document):
    class Settings:
        name = "Day"
    date : str  # Date of the day
    firebase_uid : str
    diet : Diet # List of diet entries
    outside_workout : OutsideWorkout  # List of outside workouts
    inside_workout : InsideWorkout  # List of second workouts
    water : Water  # Water intake amount
    alcohol : Alcohol  # Alcohol consumption status (e.g., Yes/No)
    pages : TenPages  # Number of pages read
