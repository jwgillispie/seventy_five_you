from beanie import Document
from pydantic import EmailStr, Field
from typing import Optional, List
# from datetime import datetime
from beanie import PydanticObjectId

class User(Document):
    class Settings:
        collection = "User"  # Specify the collection name for the User model
    firebase_uid: str
    email: EmailStr
    display_name: Optional[str]
    first_name: Optional[str]
    last_name: Optional[str]
    # ongoing_challenge: bool
    # created_at: datetime
    # role: Optional[str] = Field(default="user", max_length=20)  # Example: "admin", "user"
    # status: Optional[str] = Field(default="active")  # Example: "active", "inactive" (if account is deleted)

