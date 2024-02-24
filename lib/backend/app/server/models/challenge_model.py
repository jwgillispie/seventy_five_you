from beanie import Document
from pydantic import EmailStr
from typing import Optional, Dict

from server.models.day_model import Day

class Challenge(Document):
    class Settings:
        collection = "challenge"  # Specify the collection name for the Challenge model
    _id : str
    user_id : str
    days: Dict[str, Day]
    # Other fields for the Challenge model
