from beanie import Document
from pydantic import EmailStr
from typing import Optional
from beanie import PydanticObjectId


class Challenge(Document):
    class Settings:
        collection = "Challenge"  # Specify the collection name for the Challenge model
    firebase_uid : str # Reference to the User collection, will be firebase uid for now
    challenge_num: int
    challenge_type: str
    start_date: str
    completed: bool
    # Other fields for the Challenge model


