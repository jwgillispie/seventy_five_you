from beanie import Document
from pydantic import EmailStr
from typing import List, Optional
from datetime import datetime
class TenPages(Document):
    class Settings:
        name = "TenPages"
    date : str  # Date of the day
    firebase_uid : str
    completed: bool
    summary: str
    
