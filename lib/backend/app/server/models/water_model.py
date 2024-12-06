from beanie import Document
from pydantic import EmailStr
from typing import List, Optional
from datetime import datetime
class Water(Document):
    class Settings:
        name = "Water"
    date : str  # Date of the day
    firebase_uid : str
    completed: bool 
    pee_count: int
    completed: bool



    
