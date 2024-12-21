from beanie import Document
from pydantic import EmailStr
from typing import List, Optional
from beanie import PydanticObjectId
# from datetime import datetime


class Day(Document):
    class Settings:
        collection = "Day"
    challenge_id: PydanticObjectId # Reference to the Challenge collection
    date : str  # Date of the day
    completed: bool # not sure if necessary
    