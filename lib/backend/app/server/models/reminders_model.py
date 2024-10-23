from beanie import Document
from pydantic import EmailStr
from typing import Dict, List, Optional
from datetime import datetime
class Reminders(Document):
    class Settings:
        name = "Reminders"
    date : str  # Date of the day
    firebase_uid : str
    user_reminders : List[str] # List of user reminders


    # can have all() method that calls up all of the reminders (but for what purpose?)

