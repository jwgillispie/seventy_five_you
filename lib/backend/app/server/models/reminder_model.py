from beanie import Document
# from pydantic import EmailStr
from typing import List, Optional
from datetime import datetime

class Reminder(Document):
    class Settings:
        name = "Reminder"
    date : str  # Date of the day
    firebase_uid : str
    user_reminder : List[str] # List of user reminders
    

    
