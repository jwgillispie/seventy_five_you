from beanie import Document
from pydantic import EmailStr
from typing import Optional
from beanie import PydanticObjectId
class User(Document):
    class Settings:
        collection = "User"  # Specify the collection name for the User model
    firebase_uid: str
    email: EmailStr
    display_name: Optional[str]
    first_name: Optional[str]
    last_name: Optional[str]