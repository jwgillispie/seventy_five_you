from beanie import Document
from pydantic import EmailStr
from typing import Dict, List, Optional
from datetime import datetime
class Diet(Document):
    class Settings:
        name = "Diet"
    date : str  # Date of the day
    firebase_uid : str
    breakfast : List[str] # List of breakfast entries  
    lunch : List[str]  # List of lunch entries
    dinner : List[str]  # List of dinner entries
    snacks : List[str]  # List of snack entries
    

    
