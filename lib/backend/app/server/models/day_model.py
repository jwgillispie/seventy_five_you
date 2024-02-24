from beanie import Document
from pydantic import EmailStr
from typing import List, Optional
from datetime import datetime
class Day(Document):
    class Settings:
        name = "Day"
    date : str  # Date of the day
    firebase_uid : str
    diet : List[str]  # List of diet entries
    outside_workout : List[str]  # List of outside workouts
    second_workout : List[str]  # List of second workouts
    water : int  # Water intake amount
    alcohol : int  # Alcohol consumption status (e.g., Yes/No)
    pages : int  # Number of pages read
  
