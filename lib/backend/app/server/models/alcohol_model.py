from beanie import Document
from pydantic import EmailStr
from typing import List, Optional
from datetime import datetime
class Alcohol(Document):
    class Settings:
        name = "Alcohol"
    date : str  # Date of the day
    firebase_uid : str
    completed: bool 
    difficulty: int
    

    
