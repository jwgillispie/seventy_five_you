from beanie import Document
from pydantic import EmailStr, Field
from typing import Optional, List
from beanie import PydanticObjectId
from .day_model import Day
from .reminder_model import Reminder

class User(Document):
    class Settings:
        collection = "User"  # Specify the collection name for the User model
    firebase_uid: str
    email: EmailStr
    display_name: Optional[str]
    first_name: Optional[str]
    last_name: Optional[str]
    days: Optional[List[Day]]
    reminders: Optional[List[Reminder]]